module Main exposing (main)

import Array exposing (Array)
import Browser
import Browser.Dom
import Browser.Events
import Element exposing (Attribute, Color, Element, centerX, centerY, column, el, fill, height, htmlAttribute, layout, layoutWith, moveDown, moveLeft, newTabLink, none, padding, px, rgb255, rgba255, row, spacing, text, width)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Region as Region
import Html exposing (Html)
import Html.Attributes
import Image
import Process
import Random exposing (Generator)
import Task exposing (Task)
import Time


tan : Float -> Color
tan =
    rgba255 255 159 28


off : Color
off =
    rgb255 225 245 235


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


main : Program () Model Msg
main =
    Browser.element
        { init =
            \_ ->
                ( emptyModel
                , Cmd.batch
                    [ Browser.Dom.getViewport
                        |> Task.perform
                            (\{ viewport } ->
                                Resize
                                    { height = round viewport.height
                                    , width = round viewport.width
                                    }
                            )
                    , Random.list 40 genColor
                        |> Random.generate (Array.fromList >> ColorsCb)
                    , randomFloat
                        |> Task.perform (Just >> Hack)
                    ]
                )
        , subscriptions =
            \_ ->
                Browser.Events.onResize
                    (\width height ->
                        Resize
                            { height = height
                            , width = width
                            }
                    )
        , update = update
        , view =
            \model ->
                case model.size of
                    Just size ->
                        view size model

                    Nothing ->
                        pane
        }


type alias Model =
    { size : Maybe Size
    , colors : Array (Float -> Color)
    , hack : Bool
    }


type alias Size =
    { width : Int
    , height : Int
    }


black : Color
black =
    rgb255 0 0 0


blue : Color
blue =
    rgb255 27 79 167


font : Attribute msg
font =
    Font.family
        [ Font.typeface "Courier"
        , Font.sansSerif
        ]


pane : Html msg
pane =
    text "💥"
        |> el [ centerX, centerY ]
        |> layout [ Bg.color blue, width fill, height fill ]


view : Size -> Model -> Html msg
view size model =
    let
        big =
            size.width >= 800
    in
    column
        [ spacing 80
        , centerX
        , centerY
        ]
        [ el
            [ Region.heading 1
            , Font.bold
            , Font.size 40
            , Html.Attributes.style "cursor" "url(\"/pic.svg\"), auto"
                |> Element.htmlAttribute
            , centerX
            , font
            ]
          <|
            text "Rónán McCabe"
        , links
        ]
        |> layoutWith
            { options =
                Element.focusStyle
                    { borderColor = Nothing
                    , backgroundColor = Nothing
                    , shadow = Nothing
                    }
                    :: (if big then
                            []

                        else
                            [ Element.noHover ]
                       )
            }
            ([ Region.mainContent

             --, Bg.gradient
             --{ angle = 0
             --, steps =
             --[ Element.rgb255 150 208 255
             --, Element.rgb255 13 50 77
             --]
             --}
             , Bg.color off

             --, Font.color green
             , height fill
             , width fill
             ]
                ++ (if big then
                        pencils model.colors size

                    else
                        []
                   )
            )


type Msg
    = Resize Size
    | ColorsCb (Array (Float -> Color))
    | Hack (Maybe Float)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ColorsCb cs ->
            ( { model | colors = cs }, Cmd.none )

        Resize size ->
            ( { model | size = Just size }, Cmd.none )

        Hack mn ->
            case mn of
                Just n ->
                    ( { model | hack = False }
                    , Process.sleep (1000 * n)
                        |> Task.perform (always (Hack Nothing))
                    )

                Nothing ->
                    ( { model | hack = True }
                    , Process.sleep 250
                        |> Task.andThen (always randomFloat)
                        |> Task.perform (Just >> Hack)
                    )


randomFloat : Task Never Float
randomFloat =
    Time.now
        |> Task.map
            (Time.posixToMillis
                >> Random.initialSeed
                >> Random.step (Random.float 2 6)
                >> Tuple.first
            )


pencils : Array (Float -> Color) -> Size -> List (Attribute msg)
pencils colors size =
    List.map2 Tuple.pair
        (List.range 0 10
            |> List.map
                (\i ->
                    let
                        h_ =
                            size.height
                                // 20
                                |> clamp 90 100

                        c =
                            colors
                                |> Array.get (i + 10)
                                |> Maybe.withDefault tan
                    in
                    pencil size c
                        |> el
                            [ Element.moveDown <| toFloat <| (h_ * i)
                            ]
                        |> el
                            ([ ( "animation-name", "moveLeft" )
                             , ( "animation-duration", "2s" )
                             , ( "animation-fill-mode", "forwards" )
                             , ( "animation-delay", String.fromInt (i * 100) ++ "ms" )
                             ]
                                |> List.map
                                    (\( rule, val ) ->
                                        Html.Attributes.style rule val
                                            |> Element.htmlAttribute
                                    )
                            )
                        |> Element.inFront
                )
        )
        (List.range 0 10
            |> List.map
                (\i ->
                    let
                        h =
                            size.height
                                // 20
                                |> clamp 90 100

                        tw =
                            round (toFloat h * 1.12)

                        pw =
                            (size.width - tw) // 2

                        c =
                            colors
                                |> Array.get i
                                |> Maybe.withDefault tan
                    in
                    pencil size c
                        |> el
                            [ moveDown <| toFloat ((h * i) + (h // 2))
                            , moveLeft <| toFloat pw
                            ]
                        |> el
                            [ Html.Attributes.style "transform" "scale(-1, 1)" |> htmlAttribute
                            ]
                        |> el
                            ([ ( "animation-name", "moveRight" )
                             , ( "animation-duration", "2s" )
                             , ( "animation-fill-mode", "forwards" )
                             , ( "animation-delay", String.fromInt (i * 100) ++ "ms" )
                             ]
                                |> List.map
                                    (\( rule, val ) ->
                                        Html.Attributes.style rule val
                                            |> Element.htmlAttribute
                                    )
                            )
                        |> Element.inFront
                )
        )
        |> List.map (\( a, b ) -> [ a, b ])
        |> List.concat


links : Element msg
links =
    let
        icon =
            String.fromChar
                >> text
                >> el
                    [ Element.mouseOver
                        [ Element.rotate 0.3
                        ]
                    , Font.shadow { offset = ( 5, 5 ), blur = 0, color = black }
                    , Font.size 40
                    ]
    in
    [ ( "background", "https://stackoverflow.com/users/story/4224679", '📜' )
    , ( "code", "https://www.github.com/ronanyeah", '💻' )
    , ( "twitter", "https://www.twitter.com/ronanyeah", '🐦' )
    , ( "instagram", "https://www.instagram.com/ronanyeah", '📸' )
    , ( "work", "https://tarbh.engineering/", '🔧' )
    ]
        |> List.map
            (\( title_, url, icon_ ) ->
                newTabLink [ width fill ]
                    { url = url
                    , label =
                        [ icon icon_
                        , text title_
                        ]
                            |> row
                                [ Element.spaceEvenly
                                , width fill
                                , Border.width 2
                                , Border.color off
                                , Border.dashed
                                , Element.mouseOver
                                    [ Border.color <| rgb255 0 0 0
                                    ]
                                , padding 10
                                ]
                    }
            )
        |> column
            [ spacing 30
            , font
            , width fill
            ]


emptyModel : Model
emptyModel =
    { size = Nothing
    , colors = Array.empty
    , hack = False
    }


pencil : Size -> (Float -> Color) -> Element msg
pencil size c =
    let
        w =
            size.width

        h =
            size.height

        h_ =
            h
                // 20
                |> clamp 90 100

        tw =
            round (toFloat h_ * 1.12)

        pw =
            (w - tw) // 2
    in
    row
        [ width fill ]
        [ column
            [ height <| px h_
            , width <| px pw
            , none
                |> el [ width fill, height fill, Bg.color <| rgb255 255 255 255 ]
                |> Element.behindContent
            ]
            [ el
                [ height fill
                , width fill
                , Bg.color <| c 0.6
                , Border.width 1
                , Border.color <| rgb255 0 0 0
                ]
                none
            , el
                [ height fill
                , width fill
                , Bg.color <| c 0.8
                , Border.width 1
                , Border.color <| rgb255 0 0 0
                ]
                none
            , el
                [ height fill
                , width fill
                , Bg.color <| c 1
                , Border.width 1
                , Border.color <| rgb255 0 0 0
                ]
                none
            ]
        , el
            [ centerY
            , height fill
            , width <| px tw
            ]
            Image.tip
        ]
