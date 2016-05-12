module ThoughtDetails.Models where

import Types.Thought exposing (Thought)

type alias Model = Maybe Thought

type Action
  = ThoughtDetailsFetched (Maybe Thought)
  | FetchThought Int
