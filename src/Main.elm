module Main exposing (view)

import Color exposing (black, rgb)
import Element exposing (Attribute, Element, alignBottom, alignLeft, attribute, center, centerY, column, el, html, layout, link, newTabLink, padding, px, row, spacing, text, width)
import Element.Area as Area
import Element.Background as Background
import Element.Font as Font
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
        |> attribute


view : Html msg
view =
    layout [ Area.mainContent, Background.color <| rgb 149 175 186 ] <|
        column
            []
            [ el [ centerY ] <|
                column [ spacing 80 ]
                    [ el [ Area.heading 1, font, Font.bold, Font.size 50, Font.color black, attr "title" "☘️" ] <| text "rónán mccabe"
                    , el [ Area.heading 2, font, Font.size 30, Font.color black ] <| text "full stack developer"
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
                , Font.mouseOverColor Color.darkGreen
                ]
            <|
                html <|
                    Html.span [ Html.Attributes.class str ] []
    in
    row [ spacing 20 ]
        [ newTabLink [ center ]
            { url = "https://stackoverflow.com/users/story/4224679"
            , label = faIcon "fab fa-stack-overflow"
            }
        , link [ center ]
            { url = "mailto:hey@ronanmccabe.me"
            , label = faIcon "fas fa-envelope"
            }
        , newTabLink [ center ]
            { url = "https://www.github.com/ronanyeah"
            , label = faIcon "fab fa-github"
            }
        , newTabLink [ center ]
            { url = "https://www.twitter.com/ronanyeah"
            , label = faIcon "fab fa-twitter"
            }
        , newTabLink [ center ]
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
                , Font.mouseOverColor Color.darkGreen
                ]
            <|
                text "&lt;script&gt;&lt;/script&gt;"
        }
