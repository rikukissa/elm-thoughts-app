module Thoughts.Models where

import Time exposing (Time)
import Types.Thought exposing (Thought)
import Components.ThoughtInput as ThoughtInput

type alias Model =
  { input : ThoughtInput.Model
  , currentTime: Time
  , thoughts : List Thought
  }

type Action
  = ThoughtInputAction ThoughtInput.Action
  | Submit ThoughtInput.Action
  | NavigateTo String
  | ThoughtSaved (Maybe Thought)
  | ThoughtsFetched (Maybe (List Thought))
  | NoOp
