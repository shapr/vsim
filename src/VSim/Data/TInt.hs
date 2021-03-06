{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE DeriveDataTypeable #-}
module VSim.Data.TInt where

import Data.Typeable
import Data.Generics
import Data.Int
import Data.Bits
import Foreign.Storable
import Text.Printf

newtype TInt = TInt { unTInt :: Int32 }
    deriving (Eq, Ord, Num, Enum, Real, Integral, Storable, Bounded, Bits,
        PrintfArg, Data, Typeable)

instance Show TInt where
    showsPrec d = showsPrec d . unTInt

instance Read TInt where
    readsPrec d s = map (\(a, r) -> (TInt a, r)) $ readsPrec d s

sizeOfTInt :: Int
sizeOfTInt = fromIntegral $ sizeOf (undefined :: TInt)

