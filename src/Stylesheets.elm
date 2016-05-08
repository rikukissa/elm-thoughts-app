module Stylesheets (..) where

import Css.File exposing (CssFileStructure)
import Views.ThoughtsStyles

port files : CssFileStructure
port files =
  Css.File.toFileStructure
    [ ( "styles.css", Css.File.compile Views.ThoughtsStyles.css ) ]
