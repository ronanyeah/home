module Update exposing (update)

import Types exposing (Model, Msg(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ColorsCb cs ->
            ( { model | colors = cs }, Cmd.none )

        Flip ->
            ( { model | flip = True }, Cmd.none )

        SetDetail d ->
            ( { model
                | detail =
                    if model.detail == Just d then
                        Nothing

                    else
                        Just d
              }
            , Cmd.none
            )
