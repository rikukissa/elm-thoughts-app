module Thoughts where

import Html exposing (..)
import Signal exposing (Signal, Address)
import Effects exposing (Effects, Never)
import Http as Http
import Effects exposing (Effects, Never)
import Json.Decode as Json exposing (..)
import Html.CssHelpers
import Task as Task

import Types.Thought exposing (Thought)
import Components.ThoughtInput as ThoughtInput
import ThoughtsStyles

{ id, class, classList } =
  Html.CssHelpers.withNamespace "thoughts"

-- MODEL
type alias Model =
  { input : ThoughtInput.Model
  , thoughs : List Thought
  , lockScroll : Bool
  }

-- UPDATE
type Action
  = ThoughtInputAction ThoughtInput.Action
  | Submit ThoughtInput.Action
  | ThoughtSaved (Maybe Thought)
  | ThoughtsFetched (Maybe (List Thought))
  | NoOp

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
    , lockScroll = False
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
          , lockScroll = False
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

thoughItem : Thought -> Html
thoughItem thought =
  li [class [ThoughtsStyles.ThoughtContainer]]
    [ div [class [ThoughtsStyles.Thought]] [text thought.text]
    ]

thoughList : Signal.Address Action -> List Thought -> Html
thoughList actions thoughs =
  ul [id "thoughts", class [ThoughtsStyles.Thoughts]] (List.map thoughItem thoughs)

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
  div [ class [ThoughtsStyles.Container ] ]
    [ thoughList address model.thoughs
    , thoughtInput address model.input
    ]
