module Types.Thought where

type alias Hashtag = String

type alias Thought =
  { text : String
  , hashtags : List Hashtag
  }
