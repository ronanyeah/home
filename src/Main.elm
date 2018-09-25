module Main exposing (main)

import Element exposing (Attribute, Color, Element, alignBottom, alignLeft, centerX, centerY, column, el, fill, height, html, layoutWith, link, newTabLink, padding, px, rgb255, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Region as Region
import Html exposing (Html)
import Html.Attributes


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


main : Html msg
main =
    layoutWith
        { options =
            [ Element.focusStyle
                { borderColor = Nothing
                , backgroundColor = Nothing
                , shadow = Nothing
                }
            ]
        }
        [ Region.mainContent, Background.color blue ]
    <|
        column
            [ width fill, height fill, Font.color green ]
            [ column [ spacing 80, centerX, centerY ]
                [ el
                    [ Region.heading 1
                    , font
                    , Font.bold
                    , Font.size 50
                    , Font.shadow { offset = ( 5, 5 ), blur = 0, color = black }
                    , title "☘️"
                    , centerX
                    ]
                  <|
                    text "rónán mccabe"
                , row
                    [ "full stack developer"
                        |> text
                        |> el
                            [ Background.color blue
                            , Element.mouseOver [ Element.transparent True ]
                            ]
                        |> Element.inFront
                    , Region.heading 2
                    , font
                    , Font.size 30
                    , centerX
                    ]
                    [ text "full"
                    , el [ Font.color red, Font.letterSpacing 0.88 ] <| text " hack "
                    , text "developer"
                    ]
                , links
                ]
            , cornerLink
            ]


links : Element msg
links =
    let
        icon =
            text
                >> el
                    [ Element.mouseOver
                        [ Font.shadow { offset = ( 5, 5 ), blur = 0, color = black }
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
            , Font.size 50
            , Element.rotate 0.03
            , Element.moveRight 5
            , Element.moveUp 15
            ]
        , Font.size 30
        ]
        { url =
            "https://github.com/ronanyeah/home"
        , label =
            -- row is a hack because a script tag was breaking elm
            row [] [ text "<script src=\"💥\"><", text "/script>" ]
        }
