module Router where

import Html
import Effects exposing (Never)
import Views.Thoughts as Thoughts
import Views.ThoughtDetails as ThoughtDetails
import Effects exposing (Effects, Never)
import RouteHash
import Routes

type Action
  = ThoughtsAction Thoughts.Action
  | ThoughtDetailsAction ThoughtDetails.Action
  | ToThoughtView Int
  | NoOp

type alias Model =
  { thoughts : Thoughts.Model
  , thoughtDetails: ThoughtDetails.Model
  , currentView : Routes.Page
  }

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    ThoughtsAction thoughtsAct ->
      let
        (newThoughtsModel, newThoughtsEffects) = Thoughts.update thoughtsAct model.thoughts
      in
        ({ model | thoughts = newThoughtsModel }, Effects.map ThoughtsAction newThoughtsEffects)

    ThoughtDetailsAction thoughtsAct ->
      (model, Effects.none)

    ToThoughtView id ->
      ({ model | currentView = Routes.Thought id}, Effects.none)

    NoOp ->
      (model, Effects.none)

init : (Model, Effects Action)
init =
  let
    (initialThoughtsModel, initialThoughtsEffects) = Thoughts.init
    (initialThoughtModel, initialThoughtEffects) = ThoughtDetails.init
    initialEffects = Effects.batch
       [ Effects.map ThoughtsAction initialThoughtsEffects
       , Effects.map ThoughtDetailsAction initialThoughtEffects
       ]
  in
    ({ thoughts = initialThoughtsModel
     , thoughtDetails = initialThoughtModel
     , currentView = Routes.Thoughts
     }, initialEffects)


view : Signal.Address Action -> Model -> Html.Html
view address model =
  case model.currentView of
    Routes.Thought id ->
      (ThoughtDetails.view (Signal.forwardTo address ThoughtDetailsAction) model.thoughtDetails)
    _ ->
      (Thoughts.view (Signal.forwardTo address ThoughtsAction) model.thoughts)

location2action : List String -> List (List Action)
location2action list =
  case Routes.decode list of
    Routes.Thought id ->
      [[ToThoughtView id]]
    _ -> []


delta2update : Model -> Model -> Maybe RouteHash.HashUpdate
delta2update old new = Nothing
