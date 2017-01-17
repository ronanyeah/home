module Init exposing (..)

import Update exposing (Msg)
import Model exposing (..)
import Navigation
import Dict exposing (Dict)

init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( Model [ location ] "" Dict.empty { urls = [], topic = "" }
    , Cmd.none
    )
