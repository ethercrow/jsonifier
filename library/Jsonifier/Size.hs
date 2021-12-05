{-# LANGUAGE CPP #-}
{-# LANGUAGE UnliftedFFITypes #-}
module Jsonifier.Size
where

import Jsonifier.Prelude
import qualified Data.Text.Internal as Text
import qualified Data.Text.Array as TextArray
import qualified Jsonifier.Ffi as Ffi


{-# INLINE object #-}
object :: Int -> Int -> Int
object rowsAmount contentsSize =
  curlies + commas rowsAmount + colonsAndQuotes + contentsSize
  where
    curlies =
      2
    colonsAndQuotes =
      rowsAmount * 3

{-# INLINE array #-}
array :: Int -> Int -> Int
array elementsAmount contentsSize =
  brackets + commas elementsAmount + contentsSize
  where
    brackets =
      2

{-# INLINE commas #-}
commas :: Int -> Int
commas rowsAmount =
  if rowsAmount <= 1
    then 0
    else pred rowsAmount

{-|
Amount of bytes required for an escaped JSON string value without quotes.
-}
stringBody :: Text -> Int
#if MIN_VERSION_text(2,0,0)
stringBody (Text.Text (TextArray.ByteArray arr) off len) =
#else
stringBody (Text.Text (TextArray.aBA -> arr) off len) =
#endif
  Ffi.countStringAllocationSize
    arr (fromIntegral off) (fromIntegral len)
    & unsafeDupablePerformIO
    & fromIntegral
