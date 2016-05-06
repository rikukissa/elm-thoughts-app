module Components.ThoughtInput where

import Html exposing (..)
import Html.Attributes exposing (type', class, value)
import Html.Events exposing (onClick, on, targetValue, keyCode)
import Signal exposing (Signal, Address)
import Json.Decode as Json

-- MODEL
type alias Model =
  { text : String
  }

-- UPDATE
type Action
  = UpdateField String
  | Submit

type alias Context =
  { actions : Signal.Address Action
  , submit : Signal.Address Action
  }

update : Action -> Model -> Model
update action model =
  case action of
      UpdateField str ->
        { model | text = str }
      Submit ->
        { model |
          text = ""}

-- VIEW
view : Context -> Model -> Html
view context model =
  div []
    [ input
        [ class "form-control"
        , type' "text"
        , value model.text
        , on "input" targetValue (Signal.message context.actions << UpdateField)
        , onEnter context.submit Submit
        ]
        []
  ]

isEnter : Int -> Result String ()
isEnter code =
  if code == 13 then Ok () else Err "not the right key code"

onEnter : Address a -> a -> Attribute
onEnter address value =
    on "keydown"
      (Json.customDecoder keyCode isEnter)
      (\_ -> Signal.message address value)
