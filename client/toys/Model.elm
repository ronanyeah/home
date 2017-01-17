module Model exposing (..)

import Dict exposing (Dict)
import Navigation

type alias Gifs =
  { urls : List String
  , topic : String
  }

type alias Model =
  { history : List Navigation.Location
  , view : String
  , cracks : Dict (Int, Int) Bool
  , gifs : Gifs
  }
