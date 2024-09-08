module Types exposing (..)


type alias Model =
    { size : Screen
    , flip : Bool
    , detail : Maybe Detail
    , isMobile : Bool
    }


type alias Screen =
    { width : Int
    , height : Int
    }


type Detail
    = Proj
    | Redd
    | Talk


type alias Flags =
    { screen : Screen
    }


type Msg
    = SetDetail Detail
    | Flip


type Category
    = Product
    | Demo
    | DevContent
    | DevTool
