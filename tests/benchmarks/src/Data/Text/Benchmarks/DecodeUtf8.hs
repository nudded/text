-- | Test decoding of UTF-8
--
-- Tested in this benchmark:
--
-- * Decoding bytes using UTF-8
--
-- In some tests:
--
-- * Taking the length of the result
--
-- * Taking the init of the result
--
-- The latter are used for testing stream fusion.
--
module Data.Text.Benchmarks.DecodeUtf8
    ( benchmark
    ) where

import Criterion (Benchmark, bgroup, bench, nf)
import qualified Codec.Binary.UTF8.Generic as U8
import qualified Data.ByteString as B
import qualified Data.ByteString.Lazy as BL
import qualified Data.Text as T
import qualified Data.Text.Encoding as T
import qualified Data.Text.Lazy as TL
import qualified Data.Text.Lazy.Encoding as TL

benchmark :: FilePath -> IO Benchmark
benchmark fp = do
    bs  <- B.readFile fp
    lbs <- BL.readFile fp
    return $ bgroup "DecodeUtf8"
        [ bench "Strict" $ nf T.decodeUtf8 bs
        , bench "StrictLength" $ nf (T.length . T.decodeUtf8) bs
        , bench "StrictInitLength" $ nf (T.length . T.init . T.decodeUtf8) bs
        , bench "Lazy" $ nf TL.decodeUtf8 lbs
        , bench "LazyLength" $ nf (TL.length . TL.decodeUtf8) lbs
        , bench "LazyInitLength" $ nf (TL.length . TL.init . TL.decodeUtf8) lbs
        , bench "StrictStringUtf8" $ nf U8.toString bs
        , bench "StrictStringUtf8Length" $ nf (length . U8.toString) bs
        , bench "LazyStringUtf8" $ nf U8.toString lbs
        , bench "LazyStringUtf8Length" $ nf (length . U8.toString) lbs
        ]
