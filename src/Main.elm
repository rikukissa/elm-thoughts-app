module Main (main) where

import Html
import Effects exposing (Effects, Never)
import Task exposing (Task)
import Router exposing (router)
import StartApp
import Types.Thought as Thought exposing (Thought)

app : StartApp.App Router.Model
app =
  StartApp.start
    { init = Router.init
    , update = Router.update
    , view = Router.view
    , inputs = [Router.taggedRouterSignal]
    }

main : Signal Html.Html
main = app.html

port tasks : Signal (Task Never ())
port tasks =
  app.tasks

port scrollDown : Signal (List Thought)
port scrollDown =
  Signal.map (.thoughts << .thoughts) app.model

port routeRunTask : Task () ()
port routeRunTask =
  router.run
