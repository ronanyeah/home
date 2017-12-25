port module Tux exposing (main)

import Color exposing (black)
import Dom
import Element exposing (Attribute, button, column, el, empty, image, inputText, row, text, viewport)
import Element.Attributes exposing (center, height, id, padding, px, spacing, type_, verticalCenter, width)
import Element.Events exposing (keyCode, on, onClick, onInput)
import Html exposing (Html)
import Http
import Json.Decode exposing (Decoder, bool, decodeValue, field, int, list, map, map2, map3, nullable, string)
import Json.Encode exposing (Value, object)
import Style exposing (StyleSheet, style, stylesheet)
import Style.Border as Border
import Style.Color as Color
import Task


main : Program Value Model Msg
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


port pushUnsubscribe : () -> Cmd msg


port pushSubscription : (Value -> msg) -> Sub msg



-- MODEL


type Field
    = Pw
    | Push


type alias Saved =
    { subscription : Maybe Subscription
    , serverKey : List Int
    , pushPassword : Maybe String
    }


type alias Model =
    { message : String
    , subscription : Maybe Subscription
    , serverKey : List Int
    , pushPassword : Maybe String
    , passwordField : Maybe String
    , pushField : Maybe String
    }


type alias Subscription =
    { endpoint : String
    , keys : Keys
    }


type alias Keys =
    { auth : String
    , p256dh : String
    }



-- INIT


init : Value -> ( Model, Cmd Msg )
init json =
    let
        { serverKey, subscription, pushPassword } =
            json
                |> decodeValue savedDataDecoder
                |> Result.withDefault initSavedData

        cmd =
            case subscription of
                Nothing ->
                    Cmd.none

                Just sub ->
                    validateSubscription serverKey sub

        model =
            { message = "..."
            , subscription = subscription
            , serverKey = serverKey
            , pushPassword = pushPassword
            , passwordField = Nothing
            , pushField = Nothing
            }
    in
    model ! [ cmd ]


initSavedData : Saved
initSavedData =
    { serverKey = []
    , subscription = Nothing
    , pushPassword = Nothing
    }



-- MESSAGES


type Msg
    = SubscriptionCb Value
    | ValidateSubscriptionCb (Result Http.Error Bool)
    | Update Field String
    | Edit Field
    | FocusCb (Result Dom.Error ())
    | Cancel Field
    | Keydown Field Int
    | SetPw
    | Subscribe
    | SubscribeCb (Result Http.Error String)
    | SendPush
    | SendPushCb (Result Http.Error String)
    | ServerKeyCb (Result Http.Error (List Int))
    | Unsubscribe



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
                        { model | serverKey = [] } ! [ pushUnsubscribe () ]

                Err err ->
                    { model | message = "Subscription Validation Error" }
                        ! [ log "Subscription Validation Error:" err ]

        SubscriptionCb value ->
            let
                subscription =
                    value
                        |> decodeValue (nullable subscriptionDecoder)
                        |> Result.withDefault Nothing

                cmd =
                    case subscription of
                        Just sub ->
                            saveSub sub

                        Nothing ->
                            Cmd.none
            in
            { model | subscription = subscription } ! [ cmd ]

        ServerKeyCb res ->
            case res of
                Ok key ->
                    { model | serverKey = key } ! [ pushSubscribe key ]

                Err err ->
                    { model | message = "Server Key Error" } ! [ log "Server Key Error:" err ]

        Cancel Push ->
            { model | pushField = Nothing } ! []

        Cancel Pw ->
            { model | passwordField = Nothing } ! []

        Edit Push ->
            { model | pushField = Just "" } ! [ focusOn "input1" ]

        Edit Pw ->
            { model | passwordField = Just "" } ! [ focusOn "input2" ]

        Keydown Push key ->
            case ( key, model.pushPassword, model.pushField ) of
                ( 13, Just pw, Just txt ) ->
                    { model | pushField = Nothing } ! [ push txt pw ]

                _ ->
                    model ! []

        Keydown Pw key ->
            if key == 13 then
                { model | passwordField = Nothing, pushPassword = model.passwordField } ! []
            else
                model ! []

        Update Push val ->
            { model | pushField = Just val } ! []

        Update Pw val ->
            { model | passwordField = Just val } ! []

        SendPush ->
            case ( model.pushPassword, model.pushField ) of
                ( Just pw, Just txt ) ->
                    { model | pushField = Nothing } ! [ push txt pw ]

                _ ->
                    model ! []

        SetPw ->
            { model | passwordField = Nothing, pushPassword = model.passwordField } ! []

        Subscribe ->
            model ! [ subscribe ]

        Unsubscribe ->
            { model | message = "Unsubscribed!" } ! [ pushUnsubscribe () ]

        SubscribeCb res ->
            case res of
                Ok status ->
                    { model | message = status } ! []

                Err err ->
                    { model | message = "Error!" } ! [ log "ERROR" err ]

        SendPushCb res ->
            case res of
                Ok status ->
                    { model | message = status } ! []

                Err err ->
                    let
                        pushErr e =
                            { model | message = "Push error!" } ! [ log "Push error:" e ]
                    in
                    case err of
                        Http.BadStatus { status } ->
                            if status.code == 401 then
                                { model | message = "Incorrect password!" } ! []
                            else
                                pushErr err

                        _ ->
                            pushErr err

        FocusCb result ->
            case result of
                Ok _ ->
                    model ! []

                Err err ->
                    model ! [ log "Focus error:" err ]



-- VIEW


type Styles
    = Button
    | None


styling : StyleSheet Styles variation
styling =
    stylesheet
        [ style None []
        , style Button [ Border.dashed, Color.border black ]
        ]


view : Model -> Html Msg
view { message, pushField, passwordField, subscription } =
    let
        buttonSizes msg =
            [ onClick msg, width <| px 200, height <| px 30 ]

        smallButton msg =
            [ onClick msg, width <| px 100, height <| px 30 ]
    in
    viewport styling <|
        column None
            [ center, verticalCenter, spacing 7 ]
            [ el None [] <| image "/pwa/tux.png" None [] empty
            , el None [] <| text <| "> " ++ message
            , case subscription of
                Just _ ->
                    button <| el Button (buttonSizes Unsubscribe) <| text "unsubscribe"

                Nothing ->
                    button <| el Button (buttonSizes Subscribe) <| text "subscribe"
            , case pushField of
                Just str ->
                    column None
                        []
                        [ inputText None
                            [ id "input1"
                            , type_ "text"
                            , onKeyDown <| Keydown Push
                            , onInput <| Update Push
                            ]
                            str
                        , row None
                            [ center, spacing 5, padding 4 ]
                            [ button <| el Button (smallButton <| Cancel Push) <| text "cancel"
                            , button <| el Button (smallButton SendPush) <| text "send"
                            ]
                        ]

                Nothing ->
                    button <| el Button (buttonSizes <| Edit Push) <| text "push"
            , case passwordField of
                Just str ->
                    column None
                        []
                        [ inputText None
                            [ id "input2"
                            , type_ "password"
                            , onKeyDown <| Keydown Pw
                            , onInput <| Update Pw
                            ]
                            str
                        , row None
                            [ center, spacing 5, padding 4 ]
                            [ button <| el Button (smallButton <| Cancel Pw) <| text "cancel"
                            , button <| el Button (smallButton SetPw) <| text "set"
                            ]
                        ]

                Nothing ->
                    button <| el Button (buttonSizes <| Edit Pw) <| text "set password"
            ]



-- HELPERS


onKeyDown : (Int -> msg) -> Attribute variation msg
onKeyDown tagger =
    on "keyup" (map tagger keyCode)



-- COMMANDS


focusOn : String -> Cmd Msg
focusOn =
    Dom.focus >> Task.attempt FocusCb


push : String -> String -> Cmd Msg
push str pw =
    Http.send SendPushCb
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
    Http.send SubscribeCb
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
            (field "valid" bool)
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
    field "status" string


serverKeyDecoder : Decoder (List Int)
serverKeyDecoder =
    list int


subscriptionDecoder : Decoder Subscription
subscriptionDecoder =
    map2 Subscription
        (field "endpoint" string)
        (field "keys"
            (map2 Keys
                (field "auth" string)
                (field "p256dh" string)
            )
        )


savedDataDecoder : Decoder Saved
savedDataDecoder =
    map3 Saved
        (field "subscription" (nullable subscriptionDecoder))
        (field "serverKey" (list int))
        (field "pushPassword" (nullable string))



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
