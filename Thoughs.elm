module Thoughs where

import Debug as Debug
import Html exposing (..)
import Html.Attributes exposing (type', class, value)
import Html.Events exposing (onClick, on, targetValue, keyCode)
import Bootstrap.Html exposing (btnParam, btnPrimary_, tableBodyStriped_)
import Signal exposing (Signal, Address)
import Json.Decode as Json

import Components.ThoughtInput as ThoughtInput

-- MODEL
type alias Model =
  { input : ThoughtInput.Model
  , thoughs : List String
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
            { newModel | thoughs = model.thoughs ++ [str] }

thoughItem : String -> Html
thoughItem thought =
  li [] [text thought]

thoughList : List String -> Html
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
