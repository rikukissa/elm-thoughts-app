module Views.ThoughtDetails where

import Html exposing (..)
import Effects exposing (Effects)
import Signal exposing (Signal, Address)
import Types.Thought exposing (Thought)

type alias Model = Maybe Thought

type Action
  = ThoughtFetched (Maybe Thought)

init : (Maybe Thought, Effects Action)
init = (Nothing, Effects.none)

-- VIEW
view : Signal.Address Action -> Model -> Html
view address model =
  div [] [text "hello"]
