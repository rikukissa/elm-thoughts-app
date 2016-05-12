module Thoughts.Update where

import Task
import Effects exposing (Effects)
import Http
import Json.Decode exposing (list)
import Hop.Navigate exposing (navigateTo)

import Routing.Config exposing (..)
import Thoughts.Models exposing (Model, Action, Action(..))
import Types.Thought as Thought exposing (Thought)
import Components.ThoughtInput as ThoughtInput
import Routing.Config exposing (config)

createUrl : String
createUrl =
  "http://private-0f20ff-rikurouvila.apiary-mock.com/thoughts"

getUrl : String
getUrl =
  "http://private-0f20ff-rikurouvila.apiary-mock.com/thoughts"

getThoughts : Effects Action
getThoughts =
  Http.get (list Thought.jsonDecoder) getUrl
  |> Task.toMaybe
  |> Task.map ThoughtsFetched
  |> Effects.task

saveThought : String -> Effects Action
saveThought text =
  Http.post Thought.jsonDecoder createUrl (Http.string text)
  |> Task.toMaybe
  |> Task.map ThoughtSaved
  |> Effects.task

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    ThoughtSaved thought ->
      (model, Effects.none)

    ThoughtsFetched (Just thoughts) ->
      ({ model | thoughts = thoughts }, Effects.none)

    ThoughtsFetched Nothing ->
      (model, Effects.none)

    Submit inputAction ->
      let model =
          { model |
            thoughts = model.thoughts ++ [Thought (round model.currentTime) model.input.text []]
          , input = ThoughtInput.update inputAction model.input
          }
      in
        (model, saveThought model.input.text)

    ThoughtInputAction inputAction ->
      (
        { model | input = ThoughtInput.update inputAction model.input }
      , Effects.none
      )
    NoOp ->
      (model, Effects.none)

    NavigateTo path ->
      (model, Effects.map (always NoOp) (navigateTo config path))

show : Effects Action
show = getThoughts

init : (Model, Effects Action)
init =
  ( { input =
      { text = ""
      }
    , thoughts = []
    , currentTime = 0
    }
  , Effects.none
  )
