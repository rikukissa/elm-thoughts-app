module ThoughtDetails.Update where

import Http as Http
import Effects exposing (Effects)
import Types.Thought as Thought exposing (Thought)
import Task as Task

import ThoughtDetails.Models exposing (Model, Action, Action(..))

init : (Maybe Thought, Effects Action)
init = (Nothing, Effects.none)

getUrl : Int -> String
getUrl id =
  "http://private-0f20ff-rikurouvila.apiary-mock.com/thoughts/" ++ toString id

show : Int -> Effects Action
show = getThoughtDetails

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
