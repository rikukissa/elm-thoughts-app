module Stylesheets (..) where

import Css.File exposing (CssFileStructure)
import ThoughtsStyles

port files : CssFileStructure
port files =
  Css.File.toFileStructure
    [ ( "styles.css", Css.File.compile ThoughtsStyles.css ) ]
