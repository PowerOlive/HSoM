> {-#  LANGUAGE Arrows  #-}

> module HSoM.Examples.SpectrumAnalysis where
> import Euterpea

> import Data.Complex (Complex ((:+)), polar)
> import Data.Maybe (listToMaybe, catMaybes)

> dft :: RealFloat a => [Complex a] -> [Complex a]
> dft xs = 
>   let  lenI = length xs
>        lenR = fromIntegral lenI
>        lenC = lenR :+ 0
>   in [  let i = -2 * pi * fromIntegral k / lenR
>         in (1/lenC) * sum [  (xs!!n) * exp (0 :+ i * fromIntegral n)
>                              | n <- [0,1..lenI-1] ]
>         | k <- [0,1..lenI-1] ]

> mkTerm :: Int -> Double -> [Complex Double]
> mkTerm num n = let f = 2 * pi / fromIntegral num
>                in [  sin (n * f * fromIntegral i) / n :+ 0
>                      | i <- [0,1..num-1] ]

> mkxa, mkxb, mkxc :: Int-> [Complex Double]
> mkxa num = mkTerm num 1
> mkxb num = zipWith (+) (mkxa num) (mkTerm num 3)
> mkxc num = zipWith (+) (mkxb num) (mkTerm num 5)

> printComplexL :: [Complex Double] -> IO ()
> printComplexL xs  =
>   let  f (i,rl:+im) = 
>             do  putStr (spaces (3 - length (show i))  )
>                 putStr (show i       ++ ":  ("        )
>                 putStr (niceNum rl  ++ ", "           )
>                 putStr (niceNum im  ++ ")\n"          )
>   in mapM_ f (zip [0..length xs - 1] xs)

> niceNum :: Double -> String
> niceNum d =
>   let  d' = fromIntegral (round (1e10 * d)) / 1e10
>        (dec, fra)  = break (== '.') (show d')
>        (fra',exp)  = break (== 'e') fra
>   in  spaces (3  - length dec) ++ dec ++ take 11 fra'
>       ++ exp ++ spaces (12 - length fra' - length exp)

> spaces :: Int -> String
> spaces  n = take n (repeat ' ')

> mkPulse :: Int -> [Complex Double]
> mkPulse n = 100 : take (n-1) (repeat 0)
> {-# LINE 721 "SpectrumAnalysis.lhs" #-}
> x1 num = let f = pi * 2 * pi / fromIntegral num
>          in map (:+ 0) [  sin (f * fromIntegral i)
>                           | i <- [0,1..num-1] ]
> {-# LINE 757 "SpectrumAnalysis.lhs" #-}
> mkPolars :: [Complex Double] -> [Complex Double]
> mkPolars = map ((\(m,p)-> m:+p) . polar)
