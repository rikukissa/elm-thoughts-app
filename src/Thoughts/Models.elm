module Thoughts.Models where

import Types.Thought exposing (Thought)
import Components.ThoughtInput as ThoughtInput

type alias Model =
  { input : ThoughtInput.Model
  , thoughts : List Thought
  }

type Action
  = ThoughtInputAction ThoughtInput.Action
  | Submit ThoughtInput.Action
  | NavigateTo String
  | ThoughtSaved (Maybe Thought)
  | ThoughtsFetched (Maybe (List Thought))
  | NoOp
