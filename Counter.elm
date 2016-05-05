module Counter where
import Debug as Debug
import Html exposing (..)
import Html.Attributes exposing (type', class, value)
import Html.Events exposing (onClick, on, targetValue, keyCode)
import Bootstrap.Html exposing (btnParam, btnPrimary_, tableBodyStriped_)
import Signal exposing (Signal, Address)
import Json.Decode as Json

-- MODEL
type alias Model =
  { text : String
  , thoughs : List String
  }

-- UPDATE
type Action
  = UpdateField String
  | Submit String

update : Action -> Model -> Model
update action model =
  case action of
      UpdateField str ->
        { model | text = str }
      Submit str ->
        { model |
          text = "",
          thoughs = model.thoughs ++ [str]}

thoughItem : String -> Html
thoughItem thought =
  li [] [text thought]

thoughList : List String -> Html
thoughList thoughs =
  ul [] (List.map thoughItem thoughs)

-- VIEW
view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ thoughList model.thoughs
    , text "Add thought"
    , input
        [ class "form-control"
        , type' "text"
        , value model.text
        , on "input" targetValue (Signal.message address << UpdateField)
        , onEnter address (Submit model.text)
        ]
        []
  ]

isEnter : Int -> Result String ()
isEnter code =
  if code == 13 then Ok () else Err "not the right key code"

onEnter : Address a -> a -> Attribute
onEnter address value =
    on "keydown"
      (Json.customDecoder keyCode isEnter)
      (\_ -> Signal.message address value)
