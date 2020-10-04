module Main exposing (main)

import Array exposing (Array)
import Browser
import Element exposing (Attribute, Color, Element, centerX, centerY, column, el, fill, height, htmlAttribute, layoutWith, moveDown, moveLeft, newTabLink, none, padding, paragraph, px, rgb255, rgba255, row, spaceEvenly, spacing, text, width)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region
import Helpers.View exposing (cappedHeight, cappedWidth, style, when)
import Html exposing (Html)
import Html.Attributes
import Image
import Maybe.Extra exposing (unwrap)
import Process
import Random exposing (Generator)
import Task exposing (Task)
import Time


tan : Float -> Color
tan =
    rgba255 255 159 28


white : Color
white =
    rgb255 248 248 255


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


main : Program Size Model Msg
main =
    Browser.element
        { init =
            \size ->
                ( { emptyModel | size = size }
                , Cmd.batch
                    [ Random.list 40 genColor
                        |> Random.generate (Array.fromList >> ColorsCb)
                    , randomFloat
                        |> Task.perform (Just >> Hack)
                    ]
                )
        , subscriptions = always Sub.none
        , update = update
        , view = view
        }


type alias Model =
    { size : Size
    , colors : Array (Float -> Color)
    , hack : Bool
    , detail : Maybe Detail
    }


type alias Size =
    { width : Int
    , height : Int
    }


type Detail
    = Proj
    | Redd
    | Talk


black : Color
black =
    rgb255 0 0 0


font : Attribute msg
font =
    Font.family
        [ Font.typeface "Courier"
        , Font.sansSerif
        ]


view : Model -> Html Msg
view model =
    let
        big =
            model.size.width >= 800

        small =
            model.size.width < 375

        adj =
            if small then
                5

            else
                0

        img =
            if small then
                50

            else
                75

        sp =
            if small then
                10

            else
                20
    in
    [ [ [ text "Rónán McCabe"
            |> el
                [ Region.heading 1
                , Font.bold
                , Font.size
                    (if small then
                        25

                     else
                        35
                    )
                ]
        , Element.image
            [ height <| px img
            , width <| px img
            , shadow
            ]
            { src = "/me.png", description = "" }
        ]
            |> row [ width fill, spaceEvenly ]
      , [ text "Highlights"
            |> el [ Font.bold, Font.size (25 - adj) ]
        , model.detail
            |> unwrap
                ([ viewBtn adj Proj
                 , viewBtn adj Talk
                 , viewBtn adj Redd
                 ]
                    |> column [ spacing 20 ]
                )
                (viewDetail small)
        ]
            |> column
                [ spacing 20
                , width fill
                , padding 20
                , Bg.color white
                , shadow
                ]
      ]
        |> column [ spacing sp, width fill ]
    , links small
        |> when (model.detail == Nothing)
    ]
        |> column
            [ cappedHeight 750
            , cappedWidth 450
            , padding 20
            , spacing sp
            , centerX
            , style "animation" "fadeIn 1.2s"
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
             , Bg.gradient
                { angle = 0
                , steps =
                    [ Element.rgb255 150 208 255
                    , white
                    ]
                }
             , height fill
             , width fill
             , font
             ]
                ++ (if big then
                        pencils model.colors model.size

                    else
                        []
                   )
            )


shadow : Attribute msg
shadow =
    Border.shadow
        { offset = ( 3, 3 )
        , blur = 0
        , size = 0
        , color = black
        }


viewDetail : Bool -> Detail -> Element Msg
viewDetail small d =
    let
        txt =
            case d of
                Redd ->
                    "Free Movies"

                Proj ->
                    "Bolster"

                Talk ->
                    "Follow the Types"

        img =
            case d of
                Redd ->
                    "/freemov.png"

                Proj ->
                    "/bolster.png"

                Talk ->
                    "/talk.png"

        lnk =
            case d of
                Redd ->
                    "https://www.reddit.com/r/movies/comments/g39o5x/i_noticed_youtube_has_a_lot_of_free_movies_so_i/"

                Proj ->
                    "https://bolster.pro/"

                Talk ->
                    "https://www.youtube.com/watch?v=ly05IV5isf4"

        body =
            case d of
                Redd ->
                    [ [ text "A responsive web app presenting the free-to-watch movies on YouTube. It received ~200k impressions in the first few days of release."
                      ]
                        |> paragraph []
                    ]

                Proj ->
                    [ [ text "An end-to-end encrypted journal, currently in active development."
                      ]
                        |> paragraph []
                    ]

                Talk ->
                    [ [ text "A HasuraCon 2020 talk on statically typed programming languages and how they can be used alongside GraphQL and Hasura."
                      ]
                        |> paragraph []
                    ]
    in
    [ newTabLink
        [ Element.mouseOver [ Font.color <| Element.rgb255 255 140 0 ]
        , width fill
        ]
        { url = lnk
        , label =
            [ [ [ text txt ] |> paragraph [ Font.bold, Font.center ] ]
                |> row [ spacing 10, width fill ]
            , Element.image
                [ centerX
                , style "animation" "fadeIn 0.7s"
                , shadow
                , (if small then
                    px 100

                   else
                    fill
                  )
                    |> height
                ]
                { src = img, description = "" }
            ]
                |> column [ spacing 10, width fill ]
        }

    --, [ text title ]
    --|> paragraph [ Font.bold, Font.center ]
    , body
        |> Element.textColumn [ width fill, spacing 10, Font.size 17 ]
    , Input.button
        [ Element.mouseOver [ Font.color <| Element.rgb255 255 140 0 ]
        , Element.alignRight
        ]
        { onPress = Just <| SetDetail d
        , label =
            text "Back"
                |> el [ Font.underline ]
        }
    ]
        |> column
            [ spacing
                (if small then
                    10

                 else
                    20
                )
            , width fill
            ]


viewBtn : Int -> Detail -> Element Msg
viewBtn adj d =
    let
        txt =
            case d of
                Redd ->
                    "Reddit front page"

                Proj ->
                    "Current project"

                Talk ->
                    "Conference talk"

        emoj =
            case d of
                Redd ->
                    "👽"

                Proj ->
                    "🛠️"

                Talk ->
                    "📽️"
    in
    Input.button
        [ Element.mouseOver [ Font.color <| Element.rgb255 255 140 0 ]
        ]
        { onPress = Just <| SetDetail d
        , label =
            [ text emoj, text txt ]
                |> row [ spacing 20, Font.size (20 - adj) ]
        }


type Msg
    = ColorsCb (Array (Float -> Color))
    | Hack (Maybe Float)
    | SetDetail Detail


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ColorsCb cs ->
            ( { model | colors = cs }, Cmd.none )

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


links : Bool -> Element msg
links small =
    let
        icon =
            String.fromChar
                >> text
                >> el
                    [ Font.shadow { offset = ( 3, 3 ), blur = 0, color = black }
                    , Font.size
                        (40
                            - (if small then
                                10

                               else
                                0
                              )
                        )
                    ]
    in
    [ ( "bio", "https://stackoverflow.com/users/story/4224679", '📜' )
    , ( "code", "https://www.github.com/ronanyeah", '💻' )
    , ( "twitter", "https://www.twitter.com/ronanyeah", '🐦' )
    , ( "more projects", "https://tarbh.engineering/", '📦' )
    ]
        |> List.map
            (\( title_, url, icon_ ) ->
                newTabLink
                    [ width fill
                    , shadow
                    , Bg.color white
                    , padding 10
                    , Element.mouseOver
                        [ Bg.color black
                        , Font.color white
                        , Border.shadow
                            { offset = ( 3, 3 )
                            , blur = 0
                            , size = 0
                            , color = Element.rgb255 200 0 0
                            }
                        ]
                    ]
                    { url = url
                    , label =
                        [ icon icon_
                        , text <| title_ ++ " ↗️"
                        ]
                            |> row
                                [ Element.spaceEvenly
                                , width fill
                                , Font.size
                                    (20
                                        - (if small then
                                            5

                                           else
                                            0
                                          )
                                    )
                                ]
                    }
            )
        |> column
            [ spacing
                (if small then
                    10

                 else
                    20
                )
            , width fill
            ]


emptyModel : Model
emptyModel =
    { size = { height = 0, width = 0 }
    , colors = Array.empty
    , hack = False
    , detail = Nothing
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
