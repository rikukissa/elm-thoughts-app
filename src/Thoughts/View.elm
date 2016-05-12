module Thoughts.View where

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.CssHelpers
import Signal exposing (Address)
import Thoughts.Styles as ThoughtsStyles
import Thoughts.Models exposing (Model, Action, Action(..))
import Types.Thought as Thought exposing (Thought)
import Components.ThoughtInput as ThoughtInput

{ id, class, classList } =
  Html.CssHelpers.withNamespace "thoughts"

thoughItem : Address Action -> Thought -> Html
thoughItem address thought =
  li [ class [ThoughtsStyles.ThoughtContainer]
     , onClick address (NavigateTo "/thoughts/1")]
    [ div [class [ThoughtsStyles.Thought]] [text (thought.text)]
    ]

thoughList : Address Action -> List Thought -> Html
thoughList address thoughts =
  ul [id "thoughts", class [ThoughtsStyles.Thoughts]] (List.map (thoughItem address) thoughts)

thoughtInput : Address Action -> ThoughtInput.Model -> Html
thoughtInput address model =
  let context =
      ThoughtInput.Context
        (Signal.forwardTo address ThoughtInputAction)
        (Signal.forwardTo address Submit)
  in
    ThoughtInput.view context model

-- VIEW
view : Address Action -> Model -> Html
view address model =
  div [ class [ThoughtsStyles.Container ] ]
    [ thoughList address model.thoughts
    , thoughtInput address model.input
    ]
