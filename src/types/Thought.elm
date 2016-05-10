module Types.Thought where

import Json.Decode as Json exposing (..)

type alias Hashtag = String

type alias Thought =
  { text : String
  , hashtags : List Hashtag
  }

jsonDecoder : Decoder Thought
jsonDecoder =
  object2 Thought
    ("text" := string)
    ("hashtags" := list string)
