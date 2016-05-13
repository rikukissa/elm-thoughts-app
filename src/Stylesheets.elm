module Stylesheets (..) where

import Css.File exposing (CssFileStructure)
import Thoughts.Styles
import Components.DropdownStyles

port files : CssFileStructure
port files =
  Css.File.toFileStructure
    [ ( "styles.css", Css.File.compile Thoughts.Styles.css )
    , ( "dropdown.css", Css.File.compile Components.DropdownStyles.css ) ]
