module Router where

import Html
import Effects exposing (Never)
import Views.Thoughts as Thoughts
import Views.ThoughtDetails as ThoughtDetails
import Effects exposing (Effects, Never)
import RouteHash

type View
  = ThoughtsView
  | ThoughtDetailsView
  | NotFoundView

type Action
  = ThoughtsAction Thoughts.Action
  | ThoughtDetailsAction ThoughtDetails.Action
  | ToView View
  | NoOp

type alias Model =
  { thoughts : Thoughts.Model
  , thoughtDetails: ThoughtDetails.Model
  , currentView : View
  }

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    ThoughtsAction subAction ->
      let
        (newModel, newEffects) = Thoughts.update subAction model.thoughts
      in
        ({ model | thoughts = newModel }, Effects.map ThoughtsAction newEffects)

    ThoughtDetailsAction subAction ->
      let
        (newModel, newEffects) = ThoughtDetails.update subAction model.thoughtDetails
      in
        ({ model | thoughtDetails = newModel }, Effects.map ThoughtDetailsAction newEffects)

    ToView view ->
      ({ model | currentView = view}, Effects.none)

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
     , currentView = ThoughtsView
     }, initialEffects)


view : Signal.Address Action -> Model -> Html.Html
view address model =
  case model.currentView of
    ThoughtDetailsView ->
      (ThoughtDetails.view (Signal.forwardTo address ThoughtDetailsAction) model.thoughtDetails)
    _ ->
      (Thoughts.view (Signal.forwardTo address ThoughtsAction) model.thoughts)

location2action : List String -> List (List Action)
location2action list =
  case list of
    "" :: rest ->
      [(ToView ThoughtsView)  :: List.map ThoughtsAction ( Thoughts.location2action rest )]
    "thoughts" :: rest ->
      [(ToView ThoughtDetailsView) :: List.map ThoughtDetailsAction ( ThoughtDetails.location2action rest )]
    _ ->
      [[ToView NotFoundView]]

delta2update : Model -> Model -> Maybe RouteHash.HashUpdate
delta2update previous current =
  case current.currentView of
    ThoughtsView ->
      Just (RouteHash.set [""])
    ThoughtDetailsView ->
      RouteHash.map ((::) "thoughts") <|
        ThoughtDetails.delta2update previous.thoughtDetails current.thoughtDetails

    NotFoundView ->
      Just (RouteHash.set ["not-found"])
