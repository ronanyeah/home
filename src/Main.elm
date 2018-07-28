module Main exposing (view)

import Color exposing (black, rgb)
import Element exposing (Attribute, Element, alignBottom, alignLeft, centerX, centerY, column, el, html, layout, link, newTabLink, padding, px, row, spacing, text, width)
import Element.Background as Background
import Element.Font as Font
import Element.Region as Region
import Html exposing (Html)
import Html.Attributes


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


view : Html msg
view =
    layout [ Region.mainContent, Background.color <| rgb 149 175 186 ] <|
        column
            []
            [ el [ centerY ] <|
                column [ spacing 80 ]
                    [ el [ Region.heading 1, font, Font.bold, Font.size 50, Font.color black, attr "title" "☘️", centerX ] <| text "rónán mccabe"
                    , el [ Region.heading 2, font, Font.size 30, Font.color black, centerX ] <| text "full stack developer"
                    , links
                    ]
            , cornerLink
            ]


links : Element msg
links =
    let
        faIcon str =
            el
                [ Font.color black
                , width <| px 35
                , Font.size 30
                , Element.mouseOver [ Font.color Color.darkBlue ]
                ]
            <|
                html <|
                    Html.span [ Html.Attributes.class str ] []
    in
    row [ spacing 20 ]
        [ newTabLink [ centerX ]
            { url = "https://stackoverflow.com/users/story/4224679"
            , label = faIcon "fas fa-user"
            }
        , link [ centerX ]
            { url = "mailto:hey@ronanmccabe.me"
            , label = faIcon "fas fa-envelope"
            }
        , newTabLink [ centerX ]
            { url = "https://www.github.com/ronanyeah"
            , label = faIcon "fab fa-github"
            }
        , newTabLink [ centerX ]
            { url = "https://www.twitter.com/ronanyeah"
            , label = faIcon "fab fa-twitter"
            }
        , newTabLink [ centerX ]
            { url = "https://uk.linkedin.com/in/ronanemccabe"
            , label = faIcon "fab fa-linkedin"
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
                , Font.color Color.black
                , font
                , Element.mouseOver [ Font.color Color.darkBlue ]
                ]
            <|
                text "&lt;script&gt;&lt;/script&gt;"
        }
