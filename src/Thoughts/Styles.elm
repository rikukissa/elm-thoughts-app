module Thoughts.Styles where

import Css exposing (..)
import Css.Elements exposing (html, body, div, p)
import Css.Namespace exposing (namespace)

type CssClasses
  = Container
  | Thoughts
  | Thought
  | ThoughtContainer

fullSize : List Mixin
fullSize =
  [ height (pct 100)
  , width (pct 100)
  ]

css : Stylesheet
css =
  (stylesheet << namespace "thoughts")
    [ html fullSize
    , body (List.append fullSize [children [div fullSize]])

    , (.) Container
        [ height (pct 100)
        , width (pct 100)
        , displayFlex
        , flexDirection column
        , padding (em 2)
        , boxSizing borderBox
        ]
      , (.) Thoughts
        [ overflow auto
        , flexGrow (int 1)
        , property "list-style" "none"
        , padding zero
        ]
      , (.) ThoughtContainer
        [ nthChild "even" [paddingLeft (em 1)]
        ]
      , (.) Thought
        [ maxWidth (px 400)
        , flexGrow (int 1)
        , backgroundColor (hex "#ccc")
        , display inlineBlock
        , padding2 (em 0.75) (em 1)
        , margin2 (em 0.5) zero
        , borderRadius (px 3)
        , children [div [display inlineBlock, children [p [margin zero, display inlineBlock]]]]
        ]
    ]
