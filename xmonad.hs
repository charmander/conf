module Main (main) where

import XMonad
import Data.Map.Strict (fromList, union)
import Graphics.X11.ExtraTypes.XF86
import System.Process (spawnProcess)

amixer :: [String] -> X ()
amixer args = liftIO $ (<$) () $ spawnProcess "amixer" $ "-c" : "1" : args

keys' :: [((ButtonMask, KeySym), X ())]
keys' =
	[
		((0, xF86XK_AudioMute), amixer ["set", "Master", "toggle"]),
		((0, xF86XK_AudioLowerVolume), amixer ["set", "Master", "on", "5%-"]),
		((0, xF86XK_AudioRaiseVolume), amixer ["set", "Master", "on", "5%+"])
	]

main :: IO ()
main =
	xmonad def {
		borderWidth = 0,
		modMask = mod4Mask,
		terminal = "urxvtc",
		keys = union (fromList keys') . keys def
	}
