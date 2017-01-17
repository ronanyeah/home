module Toys exposing (..)

--import Time exposing (Time, every, second)

import Model exposing (..)
import Init exposing (..)
import Update exposing (..)
import View exposing (view)
import Navigation
import Keyboard
import Mouse


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Mouse.clicks MouseMsg
        , Keyboard.downs KeyMsg
          --, every (0.5 * second) Interval
        ]



-- MAIN


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
