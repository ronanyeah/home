module Types exposing (..)

import Element


type alias Model =
    { size : Screen
    , flip : Bool
    , isMobile : Bool
    , selectedTags : List Tag
    , selectedProject : Maybe Project
    }


type alias Screen =
    { width : Int
    , height : Int
    }


type alias Flags =
    { screen : Screen
    }


type Msg
    = Flip
    | SelectTag Tag
    | SetProject (Maybe Project)
    | ClearTags


type Tag
    = Web3
    | SuiTag
    | SolTag
    | EthTag
    | Rust
    | Elm
    | DevTooling
    | Nonsense
    | TypeTheory
    | ZK
    | Demo
    | NFT
    | Encryption


type alias Project =
    { title : String
    , url : String
    , elems : List (Element.Element Msg)
    , sourceLink : Maybe String
    , imgSrc : Maybe String
    , tags : List Tag
    }
