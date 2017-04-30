port module Tux exposing (..)

import Html exposing (Html, button, div, text, img)
import Html.Attributes exposing (src, class)
import Html.Events exposing (onClick)
import Json.Decode exposing (Decoder, at, list, string, int, bool)
import Json.Encode exposing (Value, object)
import Http
import Maybe


main : Program (Maybe Model) Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = updateWithStorage
        , subscriptions = subscriptions
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    pushSubscription SubscriptionCb



-- PORTS


port setStorage : Model -> Cmd msg


port pushSubscribe : List Int -> Cmd msg


port pushUnsubscribe : String -> Cmd msg


port pushSubscription : (Maybe Subscription -> msg) -> Sub msg



-- MODEL


type alias Model =
    { message : String
    , subscription : Maybe Subscription
    , serverKey : List Int
    }


type alias Subscription =
    { endpoint : String
    , keys :
        { auth : String
        , p256dh : String
        }
    }


emptyModel : Model
emptyModel =
    { message = "NOTHING", serverKey = [], subscription = Nothing }



-- INIT


init : Maybe Model -> ( Model, Cmd Msg )
init savedModel =
    let
        model =
            Maybe.withDefault emptyModel savedModel

        cmd =
            case model.subscription of
                Nothing ->
                    Cmd.none

                Just sub ->
                    validateSubscription model.serverKey sub
    in
        model ! [ cmd ]



-- MESSAGES


type Msg
    = Update String
    | SubscriptionCb (Maybe Subscription)
    | ValidateSubscriptionCb (Result Http.Error Bool)
    | Push
    | Subscribe
    | Unsubscribe
    | RequestCb (Result Http.Error String)
    | ServerKeyCb (Result Http.Error (List Int))



-- UPDATE


updateWithStorage : Msg -> Model -> ( Model, Cmd Msg )
updateWithStorage msg model =
    let
        ( newModel, cmds ) =
            update msg model
    in
        ( newModel
        , Cmd.batch [ setStorage newModel, cmds ]
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Update value ->
            ( model, Cmd.none )

        ValidateSubscriptionCb res ->
            case res of
                Ok valid ->
                    if valid then
                        ( model, Cmd.none )
                    else
                        ( { model | serverKey = [] }, pushUnsubscribe "foo" )

                Err err ->
                    ( model, log "ERROR" err )

        SubscriptionCb sub ->
            let
                cmd =
                    case sub of
                        Just sub ->
                            saveSub sub

                        Nothing ->
                            Cmd.none
            in
                ( { model | subscription = sub }, cmd )

        ServerKeyCb res ->
            case res of
                Ok key ->
                    ( { model | serverKey = key }, pushSubscribe key )

                Err err ->
                    ( model, log "ERROR" err )

        Push ->
            ( model, push )

        Subscribe ->
            ( model, subscribe )

        Unsubscribe ->
            ( { model | message = "Unsubscribed!" }, pushUnsubscribe "foo" )

        RequestCb res ->
            case res of
                Ok msg ->
                    ( { model | message = msg }, Cmd.none )

                Err err ->
                    ( model, log "ERROR" err )



-- VIEW


buttonClasses : String
buttonClasses =
    "db center f-5 w-80 pa2 pt4 pb4 ma3"


view : Model -> Html Msg
view model =
    div []
        [ img [ class "db center w-40 mw6 ma5", src "/pwa/tux.png" ] []
        , div [ class buttonClasses ] [ text ("Msg: " ++ model.message) ]
        , case model.subscription of
            Just _ ->
                button [ class buttonClasses, onClick Unsubscribe ] [ text "unsubscribe" ]

            Nothing ->
                button [ class buttonClasses, onClick Subscribe ] [ text "subscribe" ]
        , button [ class buttonClasses, onClick Push ] [ text "push" ]
        ]



-- COMMANDS


push : Cmd Msg
push =
    Http.send RequestCb
        (Http.post "/push"
            (Http.jsonBody
                (object
                    [ ( "password", Json.Encode.string "password" )
                    , ( "text", Json.Encode.string "hello" )
                    ]
                )
            )
            statusDecoder
        )


saveSub : Subscription -> Cmd Msg
saveSub sub =
    Http.send RequestCb
        (Http.post "/subscribe"
            (Http.jsonBody
                (encodeSubscription sub)
            )
            statusDecoder
        )


subscribe : Cmd Msg
subscribe =
    Http.send ServerKeyCb
        (Http.get "/config" serverKeyDecoder)


validateSubscription : List Int -> Subscription -> Cmd Msg
validateSubscription key sub =
    Http.send ValidateSubscriptionCb
        (Http.post "/validate"
            (Http.jsonBody
                (object
                    [ ( "subscription", encodeSubscription sub )
                    , ( "key", Json.Encode.list (List.map Json.Encode.int key) )
                    ]
                )
            )
            (at [ "valid" ] bool)
        )


log : String -> a -> Cmd Msg
log tag a =
    let
        _ =
            Debug.log tag a
    in
        Cmd.none



-- DECODERS


statusDecoder : Decoder String
statusDecoder =
    at [ "status" ] string


serverKeyDecoder : Decoder (List Int)
serverKeyDecoder =
    (list int)



-- ENCODERS


encodeSubscription : Subscription -> Value
encodeSubscription sub =
    (object
        [ ( "endpoint", Json.Encode.string sub.endpoint )
        , ( "keys"
          , object
                [ ( "p256dh", Json.Encode.string sub.keys.p256dh )
                , ( "auth", Json.Encode.string sub.keys.auth )
                ]
          )
        ]
    )
