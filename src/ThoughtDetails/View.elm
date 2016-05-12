module ThoughtDetails.View where

import Html exposing (..)
import Signal exposing (Address)

import ThoughtDetails.Models exposing (Model, Action)

view : Address Action -> Model -> Html
view address model =
  case model of
    Just thought ->
      div [] [text thought.text]
    Nothing ->
      div [] [text "Loading..."]
