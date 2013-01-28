{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE MultiParamTypeClasses #-}
-- {-# LANGUAGE FunctionalDependencies #-}

module VSim.Runtime.Elab.Array where

import Control.Applicative
import Control.Monad
import Control.Monad.Trans
import Text.Printf
import Data.Maybe
import Data.IntMap as IntMap
import Data.Array2 as Array2
import Data.Range as Range

import VSim.Runtime.Waveform
import VSim.Runtime.Time
import VSim.Runtime.Monad
import VSim.Runtime.Class
import VSim.Runtime.Ptr
import VSim.Runtime.Elab.Prim
import VSim.Runtime.Elab.Class

unpack_range :: (Monad m) => RangeT -> m [Int]
unpack_range (RangeT a b) = return [a .. b]
unpack_range (UnconstrT) = fail "attempt to list inifinite range"

alloc_array_type :: (MonadElab m) => m RangeT -> t -> m (ArrayT t)
alloc_array_type mr t = ArrayT <$> (pure t) <*> mr

-- | ArrayT of IntType generates Arrays of this type
instance (Representable t) => Representable (ArrayT t) where
    type SR (ArrayT t) = ArrayR (String, SR t)
    type VR (ArrayT t) = ArrayR (String, VR t)
    type FR (ArrayT t) = ArrayR (FR t)

replace_unconstr UnconstrT x = x
replace_unconstr (RangeT l u) _ = RangeT l u
replace_unconstr NullRangeT _ = NullRangeT

item_name :: String -> Int -> String
item_name n i = printf "%s[%d]" n i

index mi mv = mi >>= \i -> mv >>= \v -> index' i v

index' i (Value (ArrayT t UnconstrT) n _) = do
        pfail "index: not constrained: array %s" n
index' i (Value (ArrayT et rg) n a2) = do
    (en, er) <- unMaybeM (Array2.index i a2) (
        pfail "index: failure: array %s index %d" n i)
    return (Value et en er)

{- Createable -}

-- Fill unallocated array items with their default values
fixup_array (Value (ArrayT t rg) n a2) = do
    let rg' = rg `replace_unconstr` (scanRange a2)
    when_not (rg' `inner_of` rg) (pfail "fixup_array: range failure: array %s" n)
    a2' <- allocRangeM f rg' a2
    return (Value (ArrayT t rg') n a2')
    where
        f i = do
            item <- alloc (item_name n i) t defval
            return (vn item, vr item)

instance (Createable m t x)
    => Createable m (ArrayT t) (ArrayR (String,x)) where
        alloc n t f = f (Value t n Array2.empty) >>= fixup_array

{- Accessable -}

elab_access i f (Value t n a2) = do
    item <- alloc (item_name n i) (aconstr t) f
    a2' <- return (Array2.update i (vn item, vr item) a2)
    return (Value t n a2')

elab_access_all f arr@(Value t n _) = looper (arange t) where
    looper UnconstrT = do
        pfail "elab_access_all: can't loop unconstrained array: array %s" n
    looper rg = do
        loopM arr (Range.toList rg) $ \arr i -> do
            elab_access i f arr

instance (Createable (Clone m) t x) => Accessable (Clone m) (Array t x) (Value t x) where
        access' = elab_access
        access_all = elab_access_all
instance (Createable (Link m) t x) => Accessable (Link m) (Array t x) (Value t x) where
        access' = elab_access
        access_all = elab_access_all

proc_access i f (plan, val@(Value (ArrayT et _) n a2)) = do
    (en,item) <- unMaybeM (Array2.index i a2) (
        pfail "proc_access: index not found: array %s index %d" n i)
    (plan',_) <- f (plan,(Value et en item))
    return (plan',val)

instance Accessable (Assign l) (Plan, Array t x) (Plan,Value t x) where
        access' = proc_access
        access_all = error "proc_access_all undefined"

{- Assignable -}

elab_assign rh@(Value t' n' a2') lh@(Value t n a2) = do
    let is = (Range.toList $ arange t')
    a2' <- loopM a2 is (\a2 i -> do
        erh <- index' i rh
        item <- alloc (item_name n i) (aconstr t) (assign' erh)
        return (Array2.update i (vn item, vr item) a2))
    return (Value t n a2')

instance (
    Createable (Clone m) t x,
    Assignable (Clone m) (Value t x) (Value t x))
    => Assignable (Clone m) (Array t x) (Array t x) where
        assign' = elab_assign

instance (
    Createable (Link m) t x,
    Assignable (Link m) (Value t x) (Value t x))
    => Assignable (Link m) (Array t x) (Array t x) where
        assign' = elab_assign

-- FIXME: inefficient
proc_assign rh (plan,lh@(Value (ArrayT _ rg) _ _)) = do
    plan' <- loopM plan (Range.toList rg) (\p i -> do
        erh <- index' i rh
        elh <- index' i lh
        fst <$> assign' erh (p,elh))
    return (plan', lh)

instance (Assignable (Assign l) (Value t e) (Plan, Value t e))
    => Assignable (Assign l) (Array t e) (Plan, Array t e) where
        assign' = proc_assign


