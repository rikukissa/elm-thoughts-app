module Components.ThoughtInput where

import Html exposing (..)
import Html.Attributes exposing (type', class, value, autofocus)
import Html.Events exposing (onClick, on, targetValue, keyCode, onWithOptions)

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
    [ textarea
        [ class "form-control"
        , type' "text"
        , value model.text
        , autofocus True
        , on "input" targetValue (Signal.message context.actions << UpdateField)
        , onEnter context.submit Submit
        ] []
    ]

isEnter : Int -> Result String ()
isEnter code =
  if code == 13 then Ok () else Err "not the right key code"

noShiftKey : Bool -> Result String ()
noShiftKey bool =
  if not bool then Ok () else Err "shift is pressed"

onEnter : Address Action -> Action -> Attribute
onEnter address value =
    let
      options = { stopPropagation = True
                , preventDefault = True
                }
      decoder = (Json.customDecoder keyCode isEnter) `Json.andThen`
        always (Json.customDecoder (Json.at ["shiftKey"] Json.bool) noShiftKey)
    in
      onWithOptions "keydown"
        options
        decoder
        (\_ -> Signal.message address value)
