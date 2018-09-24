module Main exposing (main)

import Element exposing (Attribute, Color, Element, alignBottom, alignLeft, centerX, centerY, column, el, fill, height, html, layout, link, newTabLink, padding, px, rgb255, row, spacing, text, width)
import Element.Background as Background
import Element.Font as Font
import Element.Region as Region
import Html exposing (Html)
import Html.Attributes
import Icons


green : Color
green =
    rgb255 114 223 145


black : Color
black =
    rgb255 0 0 0


blue : Color
blue =
    rgb255 27 79 167


font : Attribute msg
font =
    Font.family
        [ Font.external
            { url = "https://fonts.googleapis.com/css?family=Lato"
            , name = "Lato"
            }
        ]


attr : String -> String -> Attribute msg
attr a b =
    Html.Attributes.attribute a b
        |> Element.htmlAttribute


main : Html msg
main =
    layout [ Region.mainContent, Background.color blue ] <|
        column
            [ width fill, height fill, Font.color green ]
            [ column [ spacing 80, centerX, centerY ]
                [ el [ Region.heading 1, font, Font.bold, Font.size 50, attr "title" "☘️", centerX ] <| text "rónán mccabe"
                , el [ Region.heading 2, font, Font.size 30, centerX ] <| text "full stack developer"
                , links
                ]
            , cornerLink
            ]


links : Element msg
links =
    let
        faIcon i =
            el
                [ width <| px 40
                , width <| px 40
                , Element.mouseOver [ Font.color black ]
                ]
            <|
                html i
    in
    row [ spacing 30, centerX ]
        [ newTabLink [ centerX ]
            { url = "https://stackoverflow.com/users/story/4224679"
            , label = faIcon Icons.user
            }
        , newTabLink [ centerX ]
            { url = "https://www.github.com/ronanyeah"
            , label = faIcon Icons.github
            }
        , newTabLink [ centerX ]
            { url = "https://www.twitter.com/ronanyeah"
            , label = faIcon Icons.twitter
            }
        , newTabLink [ centerX ]
            { url = "https://uk.linkedin.com/in/ronanemccabe"
            , label = faIcon Icons.linkedin
            }
        , newTabLink [ centerX ]
            { url = "https://open.spotify.com/playlist/4Z2VDX4fr5ciYnc6cTSir9"
            , label = faIcon Icons.headphones
            }
        ]


cornerLink : Element msg
cornerLink =
    newTabLink
        [ alignLeft
        , alignBottom
        , padding 15
        ]
        { url =
            "https://github.com/ronanyeah/home"
        , label =
            el
                [ Font.size 20
                , font
                , Element.mouseOver
                    [ Font.color
                        black
                    ]
                ]
            <|
                -- row is a hack because a script tag was breaking elm
                row [] [ text "<script src=\"🚀\"><", text "/script>" ]
        }
