module Thoughs where

import Html exposing (..)
import Signal exposing (Signal, Address)
import Effects exposing (Effects, Never)
import Http as Http

import Types.Thought exposing (Thought)
import Components.ThoughtInput as ThoughtInput
import Effects exposing (Effects, Never)
import Json.Decode exposing (..)

import Task as Task

-- MODEL
type alias Model =
  { input : ThoughtInput.Model
  , thoughs : List Thought
  }

-- UPDATE
type Action
  = ThoughtInputAction ThoughtInput.Action
  | Submit ThoughtInput.Action
  | ThoughtSaved (Maybe Thought)
  | ThoughtsFetched (Maybe (List Thought))

createUrl : String
createUrl =
  "http://private-0f20ff-rikurouvila.apiary-mock.com/thoughts"

getUrl : String
getUrl =
  "http://private-0f20ff-rikurouvila.apiary-mock.com/thoughts"

init : (Model, Effects Action)
init =
  ( { input =
      { text = ""
      }
    , thoughs = []
    }
  , getThoughts
  )

thoughtDecoder : Decoder Thought
thoughtDecoder =
  object2 Thought
    ("text" := string)
    ("hashtags" := list string)

getThoughts : Effects Action
getThoughts =
  Http.get (list thoughtDecoder) getUrl
    |> Task.toMaybe
    |> Task.map ThoughtsFetched
    |> Effects.task

saveThought : String -> Effects Action
saveThought text =
  Http.post thoughtDecoder createUrl (Http.string text)
    |> Task.toMaybe
    |> Task.map ThoughtSaved
    |> Effects.task

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    ThoughtSaved thought ->
      (model, Effects.none)

    ThoughtsFetched (Just thoughts) ->
      ({ model | thoughs = thoughts }, Effects.none)

    ThoughtsFetched Nothing ->
      (model, Effects.none)

    Submit inputAction ->
      let model =
          { model |
            thoughs = model.thoughs ++ [Thought model.input.text []]
          , input = ThoughtInput.update inputAction model.input
          }
      in
        (model, saveThought model.input.text)

    ThoughtInputAction inputAction ->
      (
        { model | input = ThoughtInput.update inputAction model.input }
      , Effects.none
      )

thoughItem : Thought -> Html
thoughItem thought =
  li [] [text thought.text]

thoughList : List Thought -> Html
thoughList thoughs =
  ul [] (List.map thoughItem thoughs)

thoughtInput : Signal.Address Action -> ThoughtInput.Model -> Html
thoughtInput address model =
  let context =
      ThoughtInput.Context
        (Signal.forwardTo address ThoughtInputAction)
        (Signal.forwardTo address Submit)
  in
    ThoughtInput.view context model

-- VIEW
view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ thoughList model.thoughs
    , text "Add thought"
    , thoughtInput address model.input
    ]
