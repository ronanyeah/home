module Update exposing (update)

import Types exposing (Model, Msg(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Flip ->
            ( { model | flip = True }, Cmd.none )

        SetProject p ->
            ( { model | selectedProject = p }, Cmd.none )

        ClearTags ->
            ( { model
                | selectedTags = []
                , selectedProject = Nothing
              }
            , Cmd.none
            )

        SelectTag t ->
            let
                tags =
                    model.selectedTags
                        |> (if List.member t model.selectedTags then
                                List.filter ((/=) t)

                            else
                                (::) t
                           )
            in
            ( { model
                | selectedTags = tags
                , selectedProject = Nothing
              }
            , Cmd.none
            )
