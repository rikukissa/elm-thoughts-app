module Types.Thought where

import Json.Decode as Json exposing (..)
import Json.Encode as Encode

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

jsonEncoder : Thought -> Encode.Value
jsonEncoder thought =
  Encode.object [ ("id", Encode.int thought.id)
                , ("hashtags", Encode.list (List.map Encode.string thought.hashtags))
                , ("text", Encode.string thought.text) 
                ]

toJson : Thought -> String
toJson thought =
  Encode.encode 0 (jsonEncoder thought)
