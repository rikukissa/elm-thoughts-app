module Main (main) where
import Html
import Effects exposing (Never)
import Thoughts as Thoughts exposing (Model, Action(Submit))
import Effects exposing (Effects, Never)
import Task

singleton : Action -> List Action
singleton action = [ action ]

messages : Signal.Mailbox (List Action)
messages =
  Signal.mailbox []

address : Signal.Address Action
address =
  Signal.forwardTo messages.address singleton

updateStep : Action -> (Model, Effects Action) -> (Model, Effects Action)
updateStep action (oldModel, accumulatedEffects) =
  let
      (newModel, additionalEffects) = Thoughts.update action oldModel
  in
      (newModel, Effects.batch [accumulatedEffects, additionalEffects])

update : List Action -> (Model, Effects Action) -> (Model, Effects Action)
update actions (model, _) =
  List.foldl updateStep (model, Effects.none) actions

effectsAndModel : Signal (Model, Effects Action)
effectsAndModel =
  Signal.foldp update Thoughts.init messages.signal

model : Signal Model
model =
  Signal.map fst effectsAndModel

main : Signal Html.Html
main = Signal.map (Thoughts.view address) model

port tasks : Signal (Task.Task Never ())
port tasks =
  Signal.map (Effects.toTask messages.address << snd) effectsAndModel

isSubmitAction : Action -> Bool
isSubmitAction act =
  case act of
    Submit _ ->
      True
    _ ->
      False

port scrollDown : Signal Bool
port scrollDown =
  Signal.map (always True) (Signal.filter (List.any isSubmitAction) [] messages.signal)
