module Update exposing (update)

import Set
import Types exposing (Model, Msg(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Flip ->
            ( { model | flip = True }, Cmd.none )

        SelectSection t ->
            let
                tags =
                    model.selectedSections
                        |> (if Set.member t model.selectedSections then
                                Set.remove t

                            else
                                Set.insert t
                           )
            in
            ( { model | selectedSections = tags }, Cmd.none )

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
