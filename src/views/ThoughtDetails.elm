module Views.ThoughtDetails where

import Html exposing (..)
import Http as Http
import Effects exposing (Effects)
import Signal exposing (Signal, Address)
import Types.Thought exposing (Thought)
import RouteHash exposing (HashUpdate)
import String exposing (toInt)
import Task as Task
import Types.Thought as Thought

type alias Model = Maybe Thought

type Action
  = ThoughtDetailsFetched (Maybe Thought)
  | FetchThought Int

init : (Maybe Thought, Effects Action)
init = (Nothing, Effects.none)

getUrl : Int -> String
getUrl id =
  "http://private-0f20ff-rikurouvila.apiary-mock.com/thoughts/" ++ toString id


getThoughtDetails : Int -> Effects Action
getThoughtDetails id =
  Http.get Thought.jsonDecoder (getUrl id)
    |> Task.toMaybe
    |> Task.map ThoughtDetailsFetched
    |> Effects.task

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    FetchThought id ->
      (model, getThoughtDetails id)

    ThoughtDetailsFetched (Just thought) ->
      (Just thought, Effects.none)

    ThoughtDetailsFetched Nothing ->
      (model, Effects.none)

-- VIEW
view : Signal.Address Action -> Model -> Html
view address model =
  div [] [text "hello"]

location2action : List String -> List Action
location2action list =
  case list of
    [] -> []
    first :: rest ->
      case toInt first of
        Ok value ->
          [FetchThought value]
        _ -> []

delta2update : Model -> Model -> Maybe HashUpdate
delta2update previous current = Nothing
