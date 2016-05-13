module Components.DropdownStyles where

import Css exposing (..)
import Css.Namespace exposing (namespace)

type CssClasses
  = Dropdown

css : Stylesheet
css =
  (stylesheet << namespace "dropdown")
    [ (.) Dropdown
        [ position absolute
        , top (em 1)
        , right (em 1)
        ]
    ]
