module Main exposing (view)

import Color
import Element exposing (Element, column, el, empty, image, link, text, row, screen, viewport)
import Element.Attributes exposing (alignBottom, alignLeft, attribute, center, class, padding, px, spacing, target, verticalCenter, width)
import Html
import Html.Attributes
import Style exposing (StyleSheet, style, stylesheet)
import Style.Color
import Style.Font as Font


type Styles
    = CornerLink
    | Description
    | Header
    | Link
    | None


font : Style.Property class variation
font =
    Font.typeface [ "Lato" ]


styling : StyleSheet Styles variation
styling =
    stylesheet
        [ style CornerLink [ font, Font.size 20, Style.Color.text Color.black ]
        , style Description [ font, Font.size 30 ]
        , style Header [ font, Font.bold, Font.size 50 ]
        , style Link [ font, Font.size 20 ]
        , style None []
        ]


view : Html.Html msg
view =
    Html.node "html"
        [ Html.Attributes.style
            [ ( "background-color", "#95AFBA" )
            , ( "cursor", "crosshair" )
            ]
        ]
        [ head
        , content
        , ga
        ]


content : Html.Html msg
content =
    viewport styling <|
        column None
            [ center, verticalCenter ]
            [ el Header [ center, class "tooltip", attribute "data-tip" "☘️" ] <| text "rónán mccabe"
            , el Description [ center, padding 30 ] <| text "full stack developer"
            , row None [ center, spacing 10 ] links
            , cornerLink
            ]


head : Html.Html msg
head =
    Html.node "head"
        []
        [ Html.node "title" [] [ Html.text "ronan mccabe" ]
        , Html.node "meta" [ Html.Attributes.charset "UTF-8" ] []
        , Html.node "meta"
            [ Html.Attributes.name "viewport"
            , Html.Attributes.content "width=device-width, initial-scale=1"
            ]
            []
        , Html.node "link"
            [ Html.Attributes.href "https://fonts.googleapis.com/css?family=Lato"
            , Html.Attributes.rel "stylesheet"
            ]
            []
        , Html.node "style"
            []
            [ Html.text tooltipCss
            ]
        ]


links : List (Element Styles variation msg)
links =
    let
        logoHeight =
            width <| px 35

        img src =
            image src None [ logoHeight ] empty
    in
        [ link "https://stackoverflow.com/users/story/4224679" <| el Link [ target "_blank" ] <| img "/logos/cv.svg"
        , link "mailto:hey@ronanmccabe.me" <| el Link [] <| img "/logos/mail.svg"
        , link "https://www.github.com/ronanyeah" <| el Link [ target "_blank" ] <| img "/logos/gh.svg"
        , link "https://www.twitter.com/ronanyeah" <| el Link [ target "_blank" ] <| img "/logos/twitter.svg"
        , link "https://uk.linkedin.com/in/ronanemccabe" <| el Link [ target "_blank" ] <| img "/logos/linkedin.svg"
        ]


cornerLink : Element Styles variation msg
cornerLink =
    screen <|
        link "https://github.com/ronanyeah/home" <|
            el CornerLink [ target "_blank", alignLeft, alignBottom, padding 15 ] <|
                text "&lt;script&gt;&lt;/script&gt;"


ga : Html.Html msg
ga =
    Html.node "script"
        []
        [ Html.text """
            (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
            (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
            m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
            })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
            ga('create', 'UA-86139022-1', 'auto');
            ga('send', 'pageview');
          """
        ]


tooltipCss : String
tooltipCss =
    """
      /* https://github.com/harrygfox/css-tooltip */

      .tooltip {
        cursor: help;
        position: relative;
      }

      .tooltip::before,
      .tooltip::after {
        position: absolute;
        left: 45%;
        opacity: 0;
        z-index: -999;
      }

      .tooltip:hover::before,
      .tooltip:hover::after {
        opacity: 1;
        z-index: 999;
      }

      .tooltip::before {
        content: "";
        border-style: solid;
        border-width: 1em 0.75em 0 0.75em;
        border-color: #8EA8C3 transparent transparent transparent;
        bottom: 100%;
        margin-left: -0.5em;
      }

      .tooltip:after {
        content: attr(data-tip);
        background-color: #8EA8C3;
        border-radius: 0.25em;
        bottom: 170%;
        width: 2.5em;
        padding: 1em 0.5em;
        margin-left: -1.5em;
        color: green;
        text-align: center;
        font-size: 0.75em;
      }
    """
