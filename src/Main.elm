module Main exposing (main)

import Browser
import Set
import Types exposing (Flags, Model, Msg(..))
import Update exposing (update)
import View exposing (view)


main : Program Flags Model Msg
main =
    Browser.element
        { init =
            \flags ->
                ( { emptyModel
                    | size = flags.screen
                    , isMobile = flags.screen.width < 1200
                  }
                , Cmd.none
                )
        , subscriptions = always Sub.none
        , update = update
        , view = view
        }


emptyModel : Model
emptyModel =
    { size = { height = 0, width = 0 }
    , detail = Nothing
    , flip = False
    , isMobile = False
    , selectedSections = Set.empty
    }
