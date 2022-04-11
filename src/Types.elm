module Types exposing (Detail(..), Flags, Model, Msg(..), Size)

import Array exposing (Array)
import Element exposing (Color)


type alias Model =
    { size : Size
    , colors : Array (Float -> Color)
    , flip : Bool
    , detail : Maybe Detail
    }


type alias Size =
    { width : Int
    , height : Int
    }


type Detail
    = Proj
    | Redd
    | Talk


type alias Flags =
    { screen : Size
    }


type Msg
    = ColorsCb (Array (Float -> Color))
    | SetDetail Detail
    | Flip
