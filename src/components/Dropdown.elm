module Components.Dropdown where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Html.CssHelpers
import Components.DropdownStyles as DropdownStyles

helpers : Html.CssHelpers.Namespace String a b
helpers = Html.CssHelpers.withNamespace "dropdown"

dropDownItem : Signal.Address a -> (String, a) -> Html
dropDownItem address (itemText, selectAction) =
   li [ title itemText ]
      [ a [ href "#", onClick address selectAction ]
          [ text itemText,
            span [ title "TODO"] [],
            span [ classList [("pull-right glyphicon glyphicon-eye-open selected", True)] ] []
          ]
      ]

dropDown : Signal.Address a -> List (String, a) -> Html
dropDown address items =
  div [ helpers.class [DropdownStyles.Dropdown] ] [
    div [ class "dropdown" ]
        [ a [ class "dropdown-toggle"
            , href "#"
            , attribute "data-toggle" "dropdown"
            , attribute "role" "button"
            ] [ text "something"
              , span [ class "caret" ] []]
        ,
          ul [ class "dropdown-menu dropdown-menu-right" ]
            (List.concat [
              [ li [ class "dropdown-menu-label" ]
                   [ span [] [] ]
              , li [ class "divider", attribute "role" "separator" ] [] ]
              , List.map (dropDownItem address) items])
        ]
  ]
