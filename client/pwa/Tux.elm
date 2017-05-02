port module Tux exposing (main)

import Html exposing (Html, button, div, text, img, input, p)
import Html.Attributes exposing (src, class, type_, id)
import Html.Events exposing (onClick, onInput)
import Json.Decode exposing (Decoder, at, list, string, int, bool)
import Json.Encode exposing (Value, object)
import Http
import Maybe
import Dom
import Task


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
subscriptions _ =
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
    , pushPassword : String
    , passwordField : Maybe String
    , pushField : Maybe String
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
    { message = "Waiting..."
    , serverKey = []
    , subscription = Nothing
    , pushPassword = ""
    , passwordField = Nothing
    , pushField = Nothing
    }



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
    = SubscriptionCb (Maybe Subscription)
    | ValidateSubscriptionCb (Result Http.Error Bool)
    | EditPush
    | UpdatePush String
    | CancelPush
    | SendPush String
    | EditPw
    | UpdatePw String
    | CancelPw
    | SetPw String
    | Subscribe
    | Unsubscribe
    | RequestCb (Result Http.Error String)
    | PushCb (Result Http.Error String)
    | FocusCb (Result Dom.Error ())
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
        ValidateSubscriptionCb res ->
            case res of
                Ok valid ->
                    if valid then
                        model ! []
                    else
                        { model | serverKey = [] } ! [ pushUnsubscribe "foo" ]

                Err err ->
                    { model | message = "Error!" } ! [ log "ERROR" err ]

        SubscriptionCb maybeSub ->
            let
                cmd =
                    case maybeSub of
                        Just sub ->
                            saveSub sub

                        Nothing ->
                            Cmd.none
            in
                { model | subscription = maybeSub } ! [ cmd ]

        ServerKeyCb res ->
            case res of
                Ok key ->
                    { model | serverKey = key } ! [ pushSubscribe key ]

                Err err ->
                    { model | message = "Error!" } ! [ log "ERROR" err ]

        EditPush ->
            { model | pushField = Just "" } ! [ focusOn "input1" ]

        UpdatePush val ->
            { model | pushField = Just val } ! []

        CancelPush ->
            { model | pushField = Nothing } ! []

        SendPush str ->
            { model | pushField = Nothing } ! [ push str model.pushPassword ]

        EditPw ->
            { model | passwordField = Just "" } ! [ focusOn "input2" ]

        UpdatePw val ->
            { model | passwordField = Just val } ! []

        CancelPw ->
            { model | passwordField = Nothing } ! []

        SetPw str ->
            { model | passwordField = Nothing, pushPassword = str } ! []

        Subscribe ->
            model ! [ subscribe ]

        Unsubscribe ->
            { model | message = "Unsubscribed!" } ! [ pushUnsubscribe "foo" ]

        RequestCb res ->
            case res of
                Ok status ->
                    { model | message = status } ! []

                Err err ->
                    { model | message = "Error!" } ! [ log "ERROR" err ]

        PushCb res ->
            case res of
                Ok status ->
                    { model | message = status } ! []

                Err err ->
                    case err of
                        Http.BadStatus res ->
                            if res.status.code == 401 then
                                { model | message = "Unauthorised!" } ! [ log "ERROR" err ]
                            else
                                { model | message = "Error!" } ! [ log "ERROR" err ]

                        _ ->
                            { model | message = "Error!" } ! [ log "ERROR" err ]

        FocusCb result ->
            case result of
                Ok _ ->
                    model ! []

                Err err ->
                    { model | message = "Error!" } ! [ log "ERROR" err ]



-- VIEW


buttonClasses : String
buttonClasses =
    "db center f-5 w-80 pa2 pt4 pb4 ma3"


smallButtonClasses : String
smallButtonClasses =
    "center f-5 w-40 pt4 pb4 ma3"


inputClasses : String
inputClasses =
    buttonClasses ++ " ba b--dotted bw3"


view : Model -> Html Msg
view model =
    div []
        [ img [ class "db center w-40 mw6 ma5", src "/pwa/tux.png" ] []
        , p [ class inputClasses ] [ text ("> " ++ model.message) ]
        , case model.subscription of
            Just _ ->
                button [ class buttonClasses, onClick Unsubscribe ] [ text "unsubscribe" ]

            Nothing ->
                button [ class buttonClasses, onClick Subscribe ] [ text "subscribe" ]
        , case model.pushField of
            Just str ->
                div []
                    [ input [ id "input1", type_ "text", onInput UpdatePush, class inputClasses ] []
                    , div [ class "flex" ]
                        [ button [ class smallButtonClasses, onClick CancelPush ] [ text "cancel" ]
                        , button [ class smallButtonClasses, onClick (SendPush str) ] [ text "send" ]
                        ]
                    ]

            Nothing ->
                button [ class buttonClasses, onClick EditPush ] [ text "push" ]
        , case model.passwordField of
            Just str ->
                div []
                    [ input [ id "input2", type_ "password", onInput UpdatePw, class inputClasses ] []
                    , div [ class "flex" ]
                        [ button [ class smallButtonClasses, onClick CancelPw ] [ text "cancel" ]
                        , button [ class smallButtonClasses, onClick (SetPw str) ] [ text "set" ]
                        ]
                    ]

            Nothing ->
                button [ class buttonClasses, onClick EditPw ] [ text "set password" ]
        ]



-- COMMANDS


focusOn : String -> Cmd Msg
focusOn i =
    Dom.focus i |> Task.attempt FocusCb


push : String -> String -> Cmd Msg
push str pw =
    Http.send PushCb
        (Http.post "/push"
            (Http.jsonBody
                (object
                    [ ( "password", Json.Encode.string pw )
                    , ( "text", Json.Encode.string str )
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
    list int



-- ENCODERS


encodeSubscription : Subscription -> Value
encodeSubscription sub =
    object
        [ ( "endpoint", Json.Encode.string sub.endpoint )
        , ( "keys"
          , object
                [ ( "p256dh", Json.Encode.string sub.keys.p256dh )
                , ( "auth", Json.Encode.string sub.keys.auth )
                ]
          )
        ]
