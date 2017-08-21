port module Tux exposing (main)

import Color
import Dom
import Element exposing (Element, button, column, el, empty, image, inputText, link, text, row, screen, viewport)
import Element.Attributes exposing (alignBottom, alignLeft, attribute, center, class, id, padding, px, spacing, target, type_, verticalCenter, width)
import Element.Events exposing (onClick, onInput)
import Html exposing (Html)
import Http
import Json.Decode exposing (Decoder, field, list, string, int, bool, map3, map2, nullable, decodeValue)
import Json.Encode exposing (Value, object)
import Style exposing (StyleSheet, style, stylesheet)
import Style.Color
import Style.Font as Font
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


port pushUnsubscribe : String -> Cmd msg


port pushSubscription : (Value -> msg) -> Sub msg



-- MODEL


type alias Saved =
    { subscription : Maybe Subscription
    , serverKey : List Int
    , pushPassword : String
    }


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
            { message = "Waiting..."
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
    , pushPassword = ""
    }



-- MESSAGES


type Msg
    = SubscriptionCb Value
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
                        Http.BadStatus { status } ->
                            if status.code == 401 then
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


type Styles
    = CornerLink
    | Description
    | Header
    | Link
    | None


styling : StyleSheet Styles variation
styling =
    stylesheet
        []


view : Model -> Html Msg
view model =
    viewport styling <|
        column None
            [ center ]
            [ el None [] <| image "/pwa/tux.png" None [] empty
            , el None [] <| text <| "> " ++ model.message
            , case model.subscription of
                Just _ ->
                    button <| el None [ onClick Unsubscribe ] <| text "unsubscribe"

                Nothing ->
                    button <| el None [ onClick Subscribe ] <| text "subscribe"
            , case model.pushField of
                Just str ->
                    column None
                        []
                        [ inputText None [ id "input1", type_ "text", onInput UpdatePush ] str
                        , row None
                            []
                            [ button <| el None [ onClick CancelPush ] <| text "cancel"
                            , button <| el None [ onClick <| SendPush str ] <| text "send"
                            ]
                        ]

                Nothing ->
                    button <| el None [ onClick EditPush ] <| text "push"
            , case model.passwordField of
                Just str ->
                    column None
                        []
                        [ inputText None [ id "input2", type_ "password", onInput UpdatePw ] str
                        , row None
                            []
                            [ button <| el None [ onClick CancelPw ] <| text "cancel"
                            , button <| el None [ onClick <| SetPw str ] <| text "set"
                            ]
                        ]

                Nothing ->
                    button <| el None [ onClick EditPw ] <| text "set password"
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
        (field "pushPassword" string)



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
