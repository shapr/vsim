{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module VSim.Runtime.Elab.Array where

import Control.Applicative
import Control.Monad
import Control.Monad.Trans
import Text.Printf
import Data.Array.IArray (IArray)
import qualified Data.Array as Array (Array)
import Data.Array2 as Array2
import Data.Maybe
import Data.IntMap as IntMap
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
    type SR (ArrayT t) = ArrayR (SR t)
    type VR (ArrayT t) = ArrayR (VR t)
    type CR (ArrayT t) = ArrayR (CR t)

fixup_range UnconstrT    a2 = (Array2.scanRange a2)
fixup_range (RangeT l u) _  = RangeT l u
fixup_range NullRangeT   _  = NullRangeT

item_name :: String -> Int -> String
item_name n i = printf "%s[%d]" n i

{- Indexable -}

instance (IArray Array.Array x, MonadPtr m) => Indexable m (Array t x) (Value t x) where
    index' i (Value n (ArrayT t UnconstrT) _) = do
            pfail "index: not constrained: array %s" n
    index' i (Value n (ArrayT et rg) a2) = liftPtr $ do
        let en = item_name n i
        er <- unMaybeM (Array2.index i a2) (
            pfail "index: failure: item %s" en)
        return (Value en et er)

{- Createable -}

fixup_array (Value n t a2) = do
    let process (i,Nothing) = do
            item <- (alloc (item_name n i) (aconstr t) >>= fixup)
            return (i, vr item)
        process (i,Just x) = do
            item <- fixup (Value (item_name n i) (aconstr t) x)
            return (i,vr item)
    let rg' = fixup_range (arange t) a2
    l <- forM (Array2.toList rg' a2) process
    return (Value n t{arange = rg'} (Array2.toArrayForm rg' l))

instance (IArray Array.Array x, Createable m t x)
    => Createable m (ArrayT t) (ArrayR x) where
        alloc n t = return (Value n t Array2.empty)
        fixup = fixup_array

{- Accessable -}

elab_access i f (Value n t a2) = do
    let en = (item_name n i)
    item <- alloc_agg en (aconstr t) f
    a2' <- return (Array2.update i (vr item) a2)
    return (Value en t a2')

elab_access_all f arr@(Value n (ArrayT t rg) a2) = array_access_all' rg where
    array_access_all' UnconstrT = do
        fail "elab_access_all: can't loop unconstrained array"
    array_access_all' rg = do
        loopM arr (Range.toList rg) $ \arr i -> do
            access' i f arr

instance (IArray Array.Array x, Createable (Clone m) t x)
    => Accessable (Clone m) (Array t x) (Value t x) where
        access' = elab_access
        access_all = elab_access_all

instance (IArray Array.Array x, Createable (Link m) t x)
    => Accessable (Link m) (Array t x) (Value t x) where
        access' = elab_access
        access_all = elab_access_all

proc_access i f val@(Value n (ArrayT et _) a2) = do
    let en = item_name n i
    item <- unMaybeM (Array2.index i a2) (
        pfail "proc_access: index not found: item %s" en)
    f (Value en et item)
    return val

instance (MonadPtr m, IArray Array.Array x) =>
    Accessable (Assign m) (Array t x) (Value t x) where
        access' = proc_access
        access_all = elab_access_all

{- Assignable -}

elab_assign rh@(Value n' t' a2') lh@(Value n t a2) = do
    let is = (Range.toList $ arange t')
    a2' <- loopM a2 is (\a2 i -> do
        erh <- index' i rh
        elh <- alloc_agg (item_name n i) (aconstr t) (assign' erh)
        return (Array2.update i (vr elh) a2))
    return (Value n t a2')

instance (
    IArray Array.Array x,
    Createable (Clone m) t x,
    Assignable (Clone m) (Value t x) (Value t x),
    Indexable (Clone m) (Array t x) (Value t x))
    => Assignable (Clone m) (Array t x) (Array t x) where
        assign' = elab_assign

instance (
    IArray Array.Array x,
    Createable (Link m) t x,
    Assignable (Link m) (Value t x) (Value t x),
    Indexable (Link m) (Array t x) (Value t x))
    => Assignable (Link m) (Array t x) (Array t x) where
        assign' = elab_assign

-- FIXME: inefficient
proc_assign rh lh@(Value _ (ArrayT _ rg) _) = do
    forM_ (Range.toList rg) (\i -> do
        erh <- index' i rh
        elh <- index' i lh
        assign' erh elh)
    return lh

instance (Assignable (Assign l) (Value t e) (Value t e),
    Indexable (Assign l) (Array t e) (Value t e))
    => Assignable (Assign l) (Array t e) (Array t e) where
        assign' = proc_assign

{- Subtypeable -}

instance Subtypeable (ArrayT t) where
    type SM (ArrayT t) = RangeT
    build_subtype r a = a{arange = r}

    valid_subtype_of (ArrayT te rg) (ArrayT te' rg') =
        (rg `inner_of` rg')


a_left :: (Monad m) => m (Array t e) -> m Int
a_left ma = ma >>= return . left . arange . vt

a_right :: (Monad m) => m (Array t e) -> m Int
a_right ma = ma >>= return . right . arange . vt


