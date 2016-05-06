module Main (main) where

import Effects exposing (Never)
import Thoughs exposing (update, view, init)
import StartApp exposing (start)
import Html exposing (Html)
import Task

app : StartApp.App Thoughs.Model
app =
  start
    { init = init
    , update = update
    , view = view
    , inputs = []
    }

main : Signal Html.Html
main = app.html

port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks
