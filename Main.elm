module Main (main) where
import Html
import Effects exposing (Never)
import Thoughts
import Effects exposing (Effects, Never)
import Task
import RouteHash
import Routes

type Action
  = ThoughtsAction Thoughts.Action
  | ToThoughtView Int

singleton : Action -> List Action
singleton action = [ action ]

type alias Model =
  { thoughts : Thoughts.Model
  , currentView : Routes.Page
  }

init : (Model, Effects Action)
init =
  let (initialThoughtsModel, initialThoughtsEffects) =
    Thoughts.init
  in
    ({ thoughts = initialThoughtsModel
     , currentView = Routes.Thoughts
     }, Effects.map ThoughtsAction initialThoughtsEffects)


messages : Signal.Mailbox (List Action)
messages =
  Signal.mailbox []

address : Signal.Address Action
address =
  Signal.forwardTo messages.address singleton

updateStep : Action -> (Model, Effects Action) -> (Model, Effects Action)
updateStep action (oldModel, accumulatedEffects) =
  case action of
    ThoughtsAction thoughtsAct ->
      let
          (newThoughtsModel, newThoughtsEffects) = Thoughts.update thoughtsAct oldModel.thoughts
          (newModel, additionalEffects) =
            ({ oldModel | thoughts = newThoughtsModel }, Effects.map ThoughtsAction newThoughtsEffects)
      in
          (newModel, Effects.batch [accumulatedEffects, additionalEffects])
    ToThoughtView id ->
      ({ oldModel | currentView = Routes.Thought id} , accumulatedEffects)

update : List Action -> (Model, Effects Action) -> (Model, Effects Action)
update actions (model, _) =
  List.foldl updateStep (model, Effects.none) actions

effectsAndModel : Signal (Model, Effects Action)
effectsAndModel =
  Signal.foldp update init messages.signal

model : Signal Model
model =
  Signal.map fst effectsAndModel

toCurrentView : Model -> Html.Html
toCurrentView model =
  case model.currentView of
    Routes.Thought id ->
      (Thoughts.view (Signal.forwardTo address ThoughtsAction) model.thoughts)
    _ ->
      (Thoughts.view (Signal.forwardTo address ThoughtsAction) model.thoughts)

main : Signal Html.Html
main = Signal.map toCurrentView model


isSubmitAction : Action -> Bool
isSubmitAction act =
  case act of
    ThoughtsAction (Thoughts.Submit _) ->
      True
    _ ->
      False

-- Ports

port tasks : Signal (Task.Task Never ())
port tasks =
  Signal.map (Effects.toTask messages.address << snd) effectsAndModel

port scrollDown : Signal Bool
port scrollDown =
  Signal.map (always True) (Signal.filter (List.any isSubmitAction) [] messages.signal)

-- Routing

location2action : List String -> List (List Action)
location2action list =
  case Routes.decode list of
    Routes.Thought id ->
      [[ToThoughtView id]]
    _ -> []


delta2update : Model -> Model -> Maybe RouteHash.HashUpdate
delta2update old new = Nothing

port routeTasks : Signal (Task.Task () ())
port routeTasks =
  RouteHash.start
    { prefix = RouteHash.defaultPrefix
    , address = messages.address
    , models = model
    , delta2update = delta2update
    , location2action = location2action
    }
