module Types exposing (..)

import Element
import Set exposing (Set)


type alias Model =
    { size : Screen
    , flip : Bool
    , detail : Maybe Detail
    , isMobile : Bool
    , selectedSections : Set String
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
    | SelectSection String


type Category
    = Product
    | Demo
    | DevContent
    | DevTool


type EcoTag
    = Sui
    | Ethereum
    | Solana


type alias Project =
    { title : String
    , url : String
    , elems : List (Element.Element Msg)
    , category : Category
    , tag : Maybe EcoTag
    , sourceLink : Maybe String
    , imgSrc : Maybe String
    }



--parcelCore title url elems category tag sourceLink imgSrc =
