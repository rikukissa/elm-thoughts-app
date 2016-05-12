module Router where

import Html
import Time exposing (Time)
import Effects exposing (Effects, Never)

import Hop
import Hop.Types exposing (Config, Router, PathMatcher, Location, newLocation)

import Thoughts.View as ThoughtView
import Thoughts.Models
import Thoughts.Update

import ThoughtDetails.Models
import ThoughtDetails.View
import ThoughtDetails.Update

import Routing.Config exposing (config, Route, Route(..))

type Action
  = ThoughtsAction Thoughts.Models.Action
  | ThoughtDetailsAction ThoughtDetails.Models.Action
  | ApplyRoute (Route, Location)
  | UpdateTime Time
  | NoOp

type alias Model =
  { thoughts : Thoughts.Models.Model
  , thoughtDetails: ThoughtDetails.Models.Model
  , location: Location
  , route: Route
  }


router : Router Route
router =
  Hop.new config

taggedRouterSignal : Signal Action
taggedRouterSignal =
  Signal.map ApplyRoute router.signal

taggedTimeSignal : Signal Action
taggedTimeSignal =
  Signal.map UpdateTime (Time.every Time.second)

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    ThoughtsAction subAction ->
      let
        (newModel, newEffects) = Thoughts.Update.update subAction model.thoughts
      in
        ({ model | thoughts = newModel }, Effects.map ThoughtsAction newEffects)

    ThoughtDetailsAction subAction ->
      let
        (newModel, newEffects) = ThoughtDetails.Update.update subAction model.thoughtDetails
      in
        ({ model | thoughtDetails = newModel }, Effects.map ThoughtDetailsAction newEffects)

    ApplyRoute (route, location) ->
      case route of
        ThoughtDetailsRoute id ->
          ({ model | route = route, location = location }, Effects.map ThoughtDetailsAction (ThoughtDetails.Update.show id))
        ThoughtsRoute ->
          ({ model | route = route, location = location }, Effects.map ThoughtsAction Thoughts.Update.show)
        _ ->
          ({ model | route = route, location = location }, Effects.none)

    UpdateTime time ->
      let
        thoughtsModel = model.thoughts
        updatedThoughtsModel = { thoughtsModel | currentTime = time }
      in
        ({model | thoughts = updatedThoughtsModel }, Effects.none)
    NoOp ->
      (model, Effects.none)

init : (Model, Effects Action)
init =
  let
    (initialThoughtsModel, initialThoughtsEffects) = Thoughts.Update.init
    (initialThoughtModel, initialThoughtEffects) = ThoughtDetails.Update.init
    initialEffects = Effects.batch
       [ Effects.map ThoughtsAction initialThoughtsEffects
       , Effects.map ThoughtDetailsAction initialThoughtEffects
       ]
  in
    ({ thoughts = initialThoughtsModel
     , thoughtDetails = initialThoughtModel
     , route = ThoughtsRoute
     , location = newLocation
     }, initialEffects)


view : Signal.Address Action -> Model -> Html.Html
view address model =
  case model.route of
    ThoughtDetailsRoute id ->
      (ThoughtDetails.View.view (Signal.forwardTo address ThoughtDetailsAction) model.thoughtDetails)
    _ ->
      (ThoughtView.view (Signal.forwardTo address ThoughtsAction) model.thoughts)
