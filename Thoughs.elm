module Thoughs where

import Html exposing (..)
import Signal exposing (Signal, Address)

import Types.Thought exposing (Thought)
import Components.ThoughtInput as ThoughtInput

-- MODEL
type alias Model =
  { input : ThoughtInput.Model
  , thoughs : List Thought
  }

-- UPDATE
type Action
  = InputAction ThoughtInput.Action


update : Action -> Model -> Model
update action model =
  case action of
    InputAction inputAction ->
      let newModel =
        { model | input = ThoughtInput.update inputAction model.input
        }
      in
        case inputAction of
          ThoughtInput.UpdateField str ->
            newModel
          ThoughtInput.Submit str ->
            { newModel | thoughs = model.thoughs ++ [{ text = str, hashtags = []}] }

thoughItem : Thought -> Html
thoughItem thought =
  li [] [text thought.text]

thoughList : List Thought -> Html
thoughList thoughs =
  ul [] (List.map thoughItem thoughs)

-- VIEW
view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ thoughList model.thoughs
    , text "Add thought"
    , ThoughtInput.view (Signal.forwardTo address InputAction) model.input
    ]
