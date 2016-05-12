module Routing.Config (..) where

import Hop.Types exposing (Config, Location, Query, Router, PathMatcher, newLocation)
import Hop.Matchers exposing (..)

type Route
  = ThoughtsRoute
  | ThoughtDetailsRoute Int
  | NotFoundRoute

matcherThoughts : PathMatcher Route
matcherThoughts =
  match1 ThoughtsRoute ""

matcherDetails : PathMatcher Route
matcherDetails =
  match2 ThoughtDetailsRoute "/thoughts/" int

matchers : List (PathMatcher Route)
matchers =
  [ matcherThoughts
  , matcherDetails
  ]

config : Config Route
config =
  { basePath = ""
  , hash = True
  , matchers = matchers
  , notFound = NotFoundRoute
  }
