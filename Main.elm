module Main (main) where
import Html
import Effects exposing (Never)
import Thoughts
import Effects exposing (Effects, Never)
import Task
import RouteHash
import Router

messages : Signal.Mailbox (List a)
messages =
  Signal.mailbox []

singleton : Router.Action -> List Router.Action
singleton action = [ action ]

address : Signal.Address Router.Action
address =
  Signal.forwardTo messages.address singleton

updateStep : Router.Action -> (Router.Model, Effects Router.Action) -> (Router.Model, Effects Router.Action)
updateStep action (oldModel, accumulatedEffects) =
  let (newModel, additionalEffects) =
    Router.update action oldModel
  in
    (newModel, Effects.batch [accumulatedEffects, additionalEffects])

update : List Router.Action -> (Router.Model, Effects Router.Action) -> (Router.Model, Effects Router.Action)
update actions (model, _) =
  List.foldl updateStep (model, Effects.none) actions

effectsAndModel : Signal (Router.Model, Effects Router.Action)
effectsAndModel =
  Signal.foldp update Router.init messages.signal

model : Signal Router.Model
model =
  Signal.map fst effectsAndModel

main : Signal Html.Html
main = Signal.map (Router.view address) model

isSubmitAction : Router.Action -> Bool
isSubmitAction act =
  case act of
    Router.ThoughtsAction (Thoughts.Submit _) ->
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

port routeTasks : Signal (Task.Task () ())
port routeTasks =
  RouteHash.start
    { prefix = RouteHash.defaultPrefix
    , address = messages.address
    , models = model
    , delta2update = Router.delta2update
    , location2action = Router.location2action
    }
