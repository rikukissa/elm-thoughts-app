module Routes where

import String
import Result exposing (andThen)
import List exposing (head)

type Page
  = Thoughts
  | Thought Int
  | NotFound


-- Page to URL string
encode : Page -> List String
encode action =
  case action of
    Thought id -> ["thoughts", (toString id)]
    Thoughts -> []
    NotFound -> ["404"]



decode : List String -> Page
decode list =
  case list of
    [] ->
      Thoughts
    [name] ->
      Thoughts
    first :: rest ->
      case first of
        "thoughts" ->
          case (Result.fromMaybe "No params" (head rest)) `andThen` String.toInt of
            Ok value ->
              Thought value

            Err _ ->
              NotFound
        _ ->
          NotFound
