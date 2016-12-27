module Main exposing (..)

import Html exposing (Html, button, div, text, input)
import Html.Attributes exposing (src, style, placeholder, value)
import Html.Events exposing (onClick, onInput)
import Dict exposing (Dict)
import Json.Decode exposing (Decoder, at, list, string)
import Http
import Keyboard
import Mouse


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { urls : List String
    , topic : String
    }


init : ( Model, Cmd Msg )
init =
    ( Model [] "", Cmd.none )



-- UPDATE


type Msg
    = MouseMsg Mouse.Position
    | KeyMsg Keyboard.KeyCode
    | Update String
    | Then (Result Http.Error (List String))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Update value ->
            ( Model model.urls value, Cmd.none )

        Then (Ok data) ->
            ( Model data model.topic, Cmd.none )

        Then (Err err) ->
            ( model, Cmd.none )

        KeyMsg code ->
            case code of
                13 ->
                    ( model, hit model.topic )

                _ ->
                    ( model, Cmd.none )

        MouseMsg _ ->
            ( Model [] model.topic, Cmd.none )



-- VIEW


gifStyle : List ( String, String )
gifStyle =
    [ ( "height", "200px" )
    , ( "width", "12.4vw" )
    , ( "display", "relative" )
    ]


inputStyle : List ( String, String )
inputStyle =
    [ ( "height", "50px" )
    , ( "margin", "50px auto" )
    , ( "display", "block" )
    ]


view : Model -> Html Msg
view model =
    div []
        (case List.length model.urls of
            0 ->
                [ input
                    [ value model.topic
                    , style inputStyle
                    , placeholder "topic"
                    , onInput Update
                    ]
                    []
                ]

            _ ->
                (List.map
                    (\url -> Html.img [ style gifStyle, src url ] [])
                    model.urls
                )
        )



-- HTTP


hit : String -> Cmd Msg
hit topic =
    let
        url =
            "http://api.giphy.com/v1/gifs/search?q=" ++ topic ++ "&limit=40&api_key=dc6zaTOxFJmzC"
    in
        Http.send Then (Http.get url decoder)


decoder : Decoder (List String)
decoder =
    at [ "data" ]
        (list
            (at [ "images", "original", "url" ] string)
        )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Mouse.clicks MouseMsg
        , Keyboard.downs KeyMsg
        ]
