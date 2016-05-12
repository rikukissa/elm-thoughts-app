module Stylesheets (..) where

import Css.File exposing (CssFileStructure)
import Thoughts.Styles

port files : CssFileStructure
port files =
  Css.File.toFileStructure
    [ ( "styles.css", Css.File.compile Thoughts.Styles.css ) ]
