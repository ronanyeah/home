module Main exposing (main)

import Array exposing (Array)
import Browser
import Browser.Dom
import Browser.Events
import Browser.Navigation
import Dict exposing (Dict)
import Element exposing (Attribute, Color, Element, alignBottom, alignLeft, alignRight, centerX, centerY, column, el, fill, height, html, htmlAttribute, layout, layoutWith, link, moveLeft, moveRight, moveUp, newTabLink, none, padding, px, rgb255, rgba255, row, spacing, text, width)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Region as Region
import Html exposing (Html)
import Html.Attributes
import Json.Decode
import Process
import Random exposing (Generator)
import Task exposing (Task)
import Time


tan : Float -> Color
tan =
    rgba255 255 159 28


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
            \model ->
                Sub.batch
                    [ Browser.Events.onResize
                        (\width height ->
                            Resize
                                { height = height
                                , width = width
                                }
                        )
                    ]
        , update = update
        , view = view
        }


type alias Model =
    { w : Int
    , h : Int
    , colors : Array (Float -> Color)
    , hack : Bool
    }


green : Color
green =
    rgb255 114 223 145


black : Color
black =
    rgb255 0 0 0


blue : Color
blue =
    rgb255 27 79 167


red : Color
red =
    rgb255 229 81 75


font : Attribute msg
font =
    Font.family
        [ Font.external
            { url = "https://fonts.googleapis.com/css?family=Lato"
            , name = "Lato"
            }
        ]


title : String -> Attribute msg
title =
    Html.Attributes.title
        >> Element.htmlAttribute


view : Model -> Html msg
view model =
    column
        [ spacing 80
        , centerX
        , centerY
        ]
        [ el
            [ Region.heading 1
            , font
            , Font.bold
            , Font.size 50
            , Font.shadow { offset = ( 5, 5 ), blur = 0, color = black }
            , title "☘️"
            , centerX
            , Html.Attributes.id "name" |> Element.htmlAttribute
            ]
          <|
            text "rónán mccabe"
        , row
            [ "full stack developer"
                |> text
                |> el
                    [ Bg.color blue
                    , Element.mouseOver [ Element.transparent True ]
                    , Element.transparent model.hack
                    ]
                |> Element.inFront
            , Region.heading 2
            , font
            , Font.size 30
            , centerX
            ]
            [ text "full"
            , el [ Font.color red, Font.letterSpacing 1.25 ] <| text " hack "
            , text "developer"
            ]
        , links
        ]
        |> layoutWith
            { options =
                [ Element.focusStyle
                    { borderColor = Nothing
                    , backgroundColor = Nothing
                    , shadow = Nothing
                    }
                ]
            }
            ([ Region.mainContent
             , Bg.color blue

             --, Element.inFront cornerLink
             --background-image: url(https://upload.wikimedia.org/wikipedia/commons/thumb/8/80/World_map_-_low_resolution.svg/950px-World_map_-_low_resolution.svg.png);
             --background-size: cover;
             --background-position: center;
             --, Element.behindContent <| el [ height fill, width fill ] <| html <| World.img2
             , Font.color green
             , height fill
             , width fill
             ]
                ++ (List.map2 Tuple.pair
                        (List.range 0 10
                            |> List.map
                                (\i ->
                                    let
                                        h_ =
                                            model.h
                                                // 20
                                                |> clamp 90 100

                                        tw =
                                            round (toFloat h_ * 1.12)

                                        pw =
                                            (model.w // 2) - tw

                                        c =
                                            model.colors
                                                |> Array.get (i + 10)
                                                |> Maybe.withDefault tan
                                    in
                                    pencil model c i
                                        |> el
                                            [ Element.moveDown <| toFloat <| (h_ * i)
                                            ]
                                        |> el
                                            ([ ( "animation-name", "moveLeft" )
                                             , ( "animation-duration", "2s" )
                                             , ( "animation-fill-mode", "forwards" )
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
                                            model.h
                                                // 20
                                                |> clamp 90 100

                                        tw =
                                            round (toFloat h * 1.12)

                                        pw =
                                            (model.w - tw) // 2

                                        bf =
                                            h // 2

                                        c =
                                            model.colors
                                                |> Array.get i
                                                |> Maybe.withDefault tan
                                    in
                                    pencil model c i
                                        |> el
                                            [ Element.moveDown <| toFloat ((h * i) + (h // 2))
                                            , Element.moveLeft <| toFloat pw
                                            ]
                                        |> el
                                            [ Html.Attributes.style "transform" "scale(-1, 1)" |> htmlAttribute
                                            ]
                                        |> el
                                            ([ ( "animation-name", "moveRight" )
                                             , ( "animation-duration", "2s" )
                                             , ( "animation-fill-mode", "forwards" )
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
                   )
            )


type Msg
    = Resize { width : Int, height : Int }
    | ColorsCb (Array (Float -> Color))
    | Hack (Maybe Float)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ColorsCb cs ->
            ( { model | colors = cs }, Cmd.none )

        Resize { width, height } ->
            ( { model | w = width, h = height }, Cmd.none )

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


links : Element msg
links =
    let
        icon =
            text
                >> el
                    [ Element.mouseOver
                        [ Font.shadow { offset = ( 5, 5 ), blur = 0, color = black }
                        , Element.rotate 0.3
                        ]
                    , Font.size 40
                    ]
    in
    row [ spacing 30, centerX ]
        [ newTabLink [ title "resume" ]
            { url = "https://stackoverflow.com/users/story/4224679"
            , label = icon "📜"
            }
        , newTabLink [ title "github" ]
            { url = "https://www.github.com/ronanyeah"
            , label = icon "💻"
            }
        , newTabLink [ title "twitter" ]
            { url = "https://www.twitter.com/ronanyeah"
            , label = icon "🐦"
            }
        , newTabLink [ title "spotify playlist" ]
            { url = "https://open.spotify.com/playlist/4Z2VDX4fr5ciYnc6cTSir9"
            , label = icon "🎧"
            }
        ]


cornerLink : Element msg
cornerLink =
    newTabLink
        [ alignLeft
        , alignBottom
        , Element.moveRight 10
        , Element.moveUp 10
        , font
        , Element.mouseOver
            [ Font.shadow { offset = ( 5, 5 ), blur = 0, color = black }
            , Font.size 40
            ]
        , Font.size 25
        ]
        { url =
            "https://github.com/ronanyeah/home"
        , label =
            -- row is a hack because a script tag was breaking elm
            row [] [ text "<script src=\"💥\"><", text "/script>" ]
        }


emptyModel : Model
emptyModel =
    { w = 0
    , h = 0
    , colors = Array.empty
    , hack = False
    }


pencil : Model -> (Float -> Color) -> Int -> Element msg
pencil { w, h } c i =
    let
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
            , Bg.image "/pencil.svg"
            , width <| px tw
            ]
            none
        ]
