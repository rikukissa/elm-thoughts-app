module Main (main) where

import Counter exposing (update, view)
import StartApp.Simple exposing (start)

main =
  start
    { model =
      { text = ""
      , thoughs = []
      }
    , update = update
    , view = view
    }
