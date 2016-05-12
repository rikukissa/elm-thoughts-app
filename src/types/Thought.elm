module Types.Thought where

import Json.Decode as Json exposing (..)

type alias Hashtag = String

type alias Thought =
  { id : Int
  , text : String
  , hashtags : List Hashtag
  }

jsonDecoder : Decoder Thought
jsonDecoder =
  object3 Thought
    ("id" := int)
    ("text" := string)
    ("hashtags" := list string)
