module Main exposing (main)

import Array
import Browser
import Element exposing (Color, rgba255)
import Random exposing (Generator)
import Types exposing (Flags, Model, Msg(..))
import Update exposing (update)
import View exposing (view)


main : Program Flags Model Msg
main =
    Browser.element
        { init =
            \flags ->
                ( { emptyModel | size = flags.screen }
                , Cmd.batch
                    [ Random.list 40 genColor
                        |> Random.generate (Array.fromList >> ColorsCb)
                    ]
                )
        , subscriptions = always Sub.none
        , update = update
        , view = view
        }


emptyModel : Model
emptyModel =
    { size = { height = 0, width = 0 }
    , colors = Array.empty
    , detail = Nothing
    , flip = False
    }


genColor : Generator (Float -> Color)
genColor =
    Random.map3
        (\a b c ->
            rgba255
                (round (255 * a))
                (round (255 * b))
                (round (255 * c))
        )
        (Random.float 0 1)
        (Random.float 0 1)
        (Random.float 0 1)
