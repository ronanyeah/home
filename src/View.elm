module View exposing (view)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region
import Helpers.View exposing (cappedWidth, style, when, whenAttr, whenJust)
import Html exposing (Html)
import Img
import Projects as P
import Set exposing (Set)
import Types exposing (..)


view : Model -> Html Msg
view model =
    let
        big =
            model.size.width >= 800

        small =
            model.size.width < 375 || model.size.height < 800

        sp =
            40

        fork =
            forkFn model.isMobile
    in
    [ [ [ Element.image
            [ width fill
            , height fill
            , Background.color <| rgb255 170 170 170
            , style "cursor" shamrock
            ]
            { src = "/me.png", description = "" }
            |> el
                [ Border.width 2
                , clip
                , width <| px 140
                , height <| px 140
                , Border.rounded 10
                , centerX
                    |> whenAttr model.isMobile
                ]
        , [ [ text "Rónán McCabe"
                |> el
                    [ Region.heading 1
                    , titleFont
                    , Font.size
                        (if small then
                            35

                         else
                            50
                        )
                    ]
            , text "Software Engineer"
                |> el
                    [ Font.size 22
                    , if model.isMobile then
                        centerX

                      else
                        alignRight
                    , Font.italic
                    ]
            ]
                |> column
                    [ spacing 5
                    , alignTop
                    , centerX
                        |> whenAttr model.isMobile
                    ]
          , let
                n =
                    35
            in
            [ newTabLink [ hover ]
                { url = "https://github.com/ronanyeah"
                , label =
                    [ Element.image
                        [ height <| px n
                        , width <| px n
                        ]
                        { src = "/github.png", description = "" }
                    ]
                        |> row [ alignRight, spacing 5 ]
                }
            , newTabLink [ hover ]
                { url = "https://t.me/ronanyeah"
                , label =
                    image [ width <| px (n + 10) ]
                        { description = ""
                        , src = Img.telegram
                        }
                }
            , newTabLink [ hover ]
                { url = "https://x.com/ronanyeah"
                , label =
                    [ Img.x (n - 5)
                    ]
                        |> row [ spacing 5 ]
                }
            ]
                |> row
                    [ alignRight
                    , spacing 15
                    , Font.size 15
                    , centerX
                        |> whenAttr model.isMobile
                    , Background.color white
                    , paddingXY 15 4
                    , Border.rounded 4
                    ]
          ]
            |> column
                (fork
                    [ spacing 20
                    , width fill
                    ]
                    [ height fill
                    , spaceEvenly
                    ]
                )
        ]
            |> fork (column [ spacing 20, width fill ]) (row [ width fill, spaceEvenly ])
      ]
        |> column [ spacing sp, width fill ]
    , [ [ text "Usually building games and experiments across the stack."
        ]
            |> paragraph [ monospaceFont ]
      , [ text "Interested in functional programming languages, smart contracts and AI-assisted development."
        ]
            |> paragraph [ monospaceFont ]
      ]
        |> column
            [ width fill
            , spacing 20
            , Border.width 2
            , Border.color white
            , Background.gradient
                { angle = degrees 0
                , steps =
                    let
                        gr n =
                            rgb255 n n n

                        half =
                            [ gr 110
                            , gr 140
                            , gr 170
                            , gr 200
                            , grey
                            , grey
                            , grey
                            , grey
                            , grey
                            ]
                    in
                    half ++ List.reverse half
                }
            , Font.color black
            , paddingXY 20 40
            , Border.rounded 4
            ]
    , [ [ parcelCore P.mineral
        , parcelCore P.warp
        , parcelCore P.pow
        , parcelCore P.terraloot
        , parcelCore P.solanaConnect
        , parcelCore P.beachwall
        ]
            |> section "Web3" model.selectedSections
      , [ parcelCore P.suiZK
        , parcelCore P.elmWebpack
        , parcelCore P.rustGql
        , parcelCore P.rustSol
        ]
            |> section "Open Source" model.selectedSections
      , [ parcelCore P.typeTalk
        , parcelCore P.fpTalk
        , parcelCore P.elmFFI
        ]
            |> section "Content" model.selectedSections
      , [ parcelCore P.movies
        , parcelCore P.restaurants
        , parcelCore P.gary
        ]
            |> section "Nonsense" model.selectedSections
      ]
        |> column [ spacing 80, width fill ]
    ]
        |> column
            [ width fill
            , height fill
            , spacing sp
            ]
        |> el
            [ fork (width fill) (cappedWidth 750)
            , height fill
            , centerX
                |> whenAttr (not model.isMobile)
            , scrollbarY
            , fork 20 80
                |> padding
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
            [ Region.mainContent
            , Background.color black
            , Font.color white
            , height fill
            , width fill
            , mainFont
            ]


linkOut : String -> List (Attribute msg) -> Element msg -> Element msg
linkOut url attrs elem =
    newTabLink
        (hover :: attrs)
        { url = url, label = elem }


header : String -> Element msg
header =
    text
        >> el
            [ Font.size 45
            , Font.bold
            , Font.color black
            , Background.color white
            , paddingEach { left = 20, right = 20, top = 10, bottom = 10 }
            ]


section : String -> Set String -> List (Element Msg) -> Element Msg
section title selected elems =
    [ el [ Background.color white, height fill, width <| px 3 ] none
    , [ header title
            |> btn (Just <| SelectSection title)
      , elems
            |> List.map
                (\g ->
                    [ el [ height fill, width <| px 20 ] none
                    , g
                    ]
                        |> row [ width fill ]
                )
            |> List.intersperse
                (el
                    [ height <| px 3
                    , width fill
                    , Background.color white
                    ]
                    none
                )
            |> (\xs ->
                    xs
                        ++ [ el
                                [ height <| px 3
                                , width fill
                                , Background.color white
                                ]
                                none
                           ]
               )
            |> column [ spacing 30, width fill ]
            |> when (Set.member title selected)
      ]
        |> column [ spacing 20, width fill ]
    ]
        |> row [ width fill ]


parcelCore : Project -> Element Msg
parcelCore project =
    let
        { title, url, elems, category, tag, sourceLink, imgSrc } =
            project
    in
    [ [ [ [ text title
                |> linkOut url
                    [ Font.underline
                    , Font.bold
                    , Font.size 45
                    ]
          ]
            |> paragraph []
        , tag
            |> whenJust
                (\ecoTag ->
                    case ecoTag of
                        Sui ->
                            suiIcon

                        Solana ->
                            solIcon

                        Ethereum ->
                            ethIcon
                )
            |> el [ alignTop ]
        ]
            |> row [ spaceEvenly, width fill ]
      , elems
            |> paragraph
                [ textFont
                , Font.size 20
                ]
      ]
        |> column [ spacing 30, width fill ]
    , [ sourceLink
            |> whenJust
                (\code ->
                    newTabLink
                        [ hover
                        , Font.underline
                        , monospaceFont
                        , Font.italic
                        , Font.size 17
                        ]
                        { url = code
                        , label = text "source code"
                        }
                )
      , catToString category
            |> text
            |> el [ Font.italic, alignRight, monospaceFont ]
      ]
        |> row [ width fill ]
    , imgSrc
        |> whenJust
            (\src ->
                image
                    [ width fill
                    , Border.width 1
                    , Border.color white
                    ]
                    { src = src, description = "" }
            )
    ]
        |> column [ spacing 30, width fill, paddingXY 0 80 ]


solIcon : Element msg
solIcon =
    bubbleTag "https://solana.com/" "Solana" Img.solana 17


suiIcon : Element msg
suiIcon =
    bubbleTag "https://sui.io/" "Sui" Img.sui 17


bubbleTag : String -> String -> (Int -> Element msg) -> Int -> Element msg
bubbleTag url txt img size =
    newTabLink
        [ hover
        , Background.color <| rgb255 220 220 220
        , Border.rounded 20
        , paddingXY 13 8
        , Font.color black
        ]
        { url = url
        , label =
            [ img size
            , tagTxt txt
            ]
                |> row
                    [ spacing 7
                    , Font.size size
                    ]
        }


tagTxt : String -> Element msg
tagTxt =
    text
        >> el
            [ textFont
            , Font.bold
            ]


ethIcon : Element msg
ethIcon =
    bubbleTag "https://ethereum.org/" "Ethereum" Img.ethereum 17


forkFn : Bool -> a -> a -> a
forkFn bool a b =
    if bool then
        a

    else
        b


fade : Element.Attr a b
fade =
    Element.alpha 0.7


shamrock : String
shamrock =
    let
        shm =
            "☘️"
    in
    "url(\"data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='40' height='40' viewport='0 0 100 100' style='font-size:24px;'><text y='50%'>" ++ shm ++ "</text></svg>\"), auto"


hover : Attribute msg
hover =
    Element.mouseOver [ fade ]


catToString : Category -> String
catToString cat =
    case cat of
        Product ->
            ""

        Demo ->
            "--demo"

        DevContent ->
            "--dev-content"

        DevTool ->
            "--dev-tool"


btn : Maybe msg -> Element msg -> Element msg
btn msg elem =
    Input.button
        [ hover
            |> whenAttr (msg /= Nothing)
        ]
        { onPress = msg
        , label = elem
        }


grey : Color
grey =
    rgb255 235 235 235


white : Color
white =
    rgb255 255 255 255


black : Color
black =
    rgb255 0 0 0


monospaceFont : Attribute msg
monospaceFont =
    Font.family [ Font.monospace ]


textFont : Attribute msg
textFont =
    Font.family [ Font.typeface "Montserrat Variable" ]


mainFont : Attribute msg
mainFont =
    Font.family [ Font.typeface "Archivo Variable" ]


titleFont : Attribute msg
titleFont =
    Font.family [ Font.typeface "IBM Plex Mono" ]
