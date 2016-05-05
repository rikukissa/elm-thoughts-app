module Main (main) where

import Thoughs exposing (update, view)
import StartApp.Simple exposing (start)

main =
  start
    { model =
      { input =
        { text = ""
        }
      , thoughs = []
      }
    , update = update
    , view = view
    }
