module View exposing (view)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region
import Helpers.View exposing (cappedHeight, cappedWidth, style, when, whenAttr, whenJust)
import Html exposing (Html)
import Img
import Maybe.Extra exposing (unwrap)
import Types exposing (Detail(..), Model, Msg(..))


tan : Float -> Color
tan =
    rgba255 255 159 28


orange : Color
orange =
    Element.rgb255 255 140 0


white : Color
white =
    --rgb255 248 248 255
    rgb255 255 255 255


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
            model.size.width < 375 || model.size.height < 800

        adj =
            if small then
                5

            else
                0

        img =
            if small then
                50

            else
                125

        sp =
            if small then
                10

            else
                20

        fork =
            forkFn model.isMobile
    in
    [ [ [ Element.image
            [ --height <| px img
              --width <| px img
              --height <| px 120
              shadow
            , width <| px 140
            , Background.color <| rgb255 170 170 170
            , style "cursor" shamrock
            ]
            --{ src = "/new2.svg", description = "" }
            { src = "/me.png", description = "" }
            |> el
                [ Border.width 2
                , centerX
                    |> whenAttr model.isMobile
                ]
        , [ [ text "Rónán McCabe"
                |> el
                    [ Region.heading 1

                    --, Font.bold
                    --, Font.family [ Font.typeface "Tiro Devanagari Marathi" ]
                    , Font.bold
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

                    --, text "ronanyeah"
                    --|> el [ centerY ]
                    ]
                        |> row [ alignRight, spacing 5 ]
                }
            , newTabLink [ hover ]
                { url = "https://twitter.com/ronanyeah"
                , label =
                    [ Img.twitter n

                    --, text "ronanyeah"
                    --|> el [ centerY ]
                    ]
                        |> row [ spacing 5 ]
                }
            ]
                |> row
                    [ alignRight
                    , spacing 20
                    , Font.size 15
                    , centerX
                        |> whenAttr model.isMobile
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

        --, Element.image
        --[ height <| px img
        --, width <| px img
        --, shadow
        --]
        --{ src = "/me.png", description = "" }
        --|> when False
        ]
            |> fork (column [ spacing 20, width fill ]) (row [ width fill, spaceEvenly ])
      , [ [ text "Currently building with" ]
            |> paragraph [ Font.bold, Font.size (22 - adj) ]
        , [ "Elm", "Rust", "GraphQL", "Hasura", "DApp", "PWA", "Web Crypto", "Smart Contracts", "MetaMask", "Arweave", "IPFS", "Ethereum", "Polkadot", "NFT", "Cardano" ]
            |> List.map
                (text
                    >> el
                        [ Font.italic
                        , Font.size
                            (if big then
                                17

                             else
                                15
                            )
                        , Border.width 1
                        , padding 5
                        ]
                )
            |> Element.wrappedRow [ spacing 10 ]
        ]
            |> column
                [ spacing sp
                , width fill
                , Background.color white
                , shadow
                ]
            |> when False
      , [ text "Projects"
            |> el [ Font.bold, Font.size (25 - adj) ]
        , model.detail
            |> unwrap
                ([ viewBtn adj Proj
                 , viewBtn adj Talk
                 , viewBtn adj Redd
                 ]
                    |> column
                        [ spacing sp
                        ]
                )
                (viewDetail small)
        ]
            |> column
                [ spacing sp
                , width fill
                , padding sp
                , Background.color white
                , shadow
                ]
            |> when False
      , [ [ text "Software Engineer"
                |> el [ Font.size 20 ]
          , text "more"
                |> el [ Font.underline, Font.size 14, alignBottom ]
          ]
            |> row [ spacing 10 ]
            |> when False
        ]
            |> column [ spacing 10 ]
      ]
        |> column [ spacing sp, width fill ]
    , text "Technical Experience"
        |> el [ Font.underline ]
        |> when False
    , [ [ parcelTag "Bagwatch" "https://bagwatch.app/" "A dashboard displaying social media analytics related to upcoming Solana NFT collections." (Just solIcon)
        , parcelCore "NestQuest"
            "https://nestquest.io/"
            [ text "An NFT project I have been working on with "
            , paraLink "GooseFX" "https://goosefx.io/"
            , text ". It is an interactive tutorial and rewards program for the GooseFX "
            , paraLink "DeFi platform" "https://app.goosefx.io/"
            , text "."
            ]
            (Just solIcon)
        , parcelTag "Rust Client Examples"
            "https://github.com/ronanyeah/solana-scripts"
            "A selection of scripts demonstrating how to use Rust to interact with the Solana blockchain."
            (Just solIcon)
        , parcelCore "Arena"
            "https://arena.bond/"
            [ text "An onchain Rock/Paper/Scissors game. It was "
            , paraLink "demoed live" "https://twitter.com/hackerhouses/status/1494998129779027973"
            , text " at Hacker House Dubai 2022."
            ]
            (Just solIcon)
        , parcelCore "Terraloot"
            "https://terraloot.dev/"
            [ text "A Mars terraforming themed "
            , paraLink "ERC-721"
                "https://ethereum.org/en/developers/docs/standards/tokens/erc-721/"
            , text " NFT, inspired by "
            , paraLink "Loot" "https://www.lootproject.com/"
            , text "."
            ]
            (Just ethIcon)
        , parcelCore "Gascheck"
            "https://gascheck.tools/"
            [ text "An "
            , paraLink "EIP-1559" "https://notes.ethereum.org/@vbuterin/eip-1559-faq"
            , text " gas cost calculator for Ethereum transactions."
            ]
            (Just ethIcon)
        ]
            |> section "Web3"
      , [ parcel "Follow the Types (2020)"
            "https://hasura.io/events/hasura-con-2020/talks/bugs-cant-hide-a-full-stack-exploration-in-type-safety/"
            "A talk I presented at HasuraCon 2020 about how strongly typed languages can be used alongside GraphQL to enforce full stack type safety."

        -- https://www.meetup.com/MancJS/events/242088443/
        , parcelCore
            "Functional Programming in JavaScript (2017)"
            "https://slides.com/ronanmccabe/fp-in-js"
            [ text "A talk on functional programming techniques in JS I presented at "
            , paraLink "MancJS" "https://www.meetup.com/MancJS/events/242088443/"
            , text "."
            ]
            Nothing
        , parcelCore "Elm + Webpack Example"
            "https://github.com/ronanyeah/elm-webpack"
            [ text "A template for starting an "
            , paraLink "Elm" "https://elm-lang.org/"
            , text " project. It supports live reload development, and production builds."
            ]
            Nothing
        , parcelCore "Rust + Async + GraphQL Example"
            "https://github.com/ronanyeah/rust-hasura"
            [ text "An example of a Rust server that functions as a "
            , paraLink "remote schema" "https://hasura.io/docs/latest/graphql/core/remote-schemas/index/"
            , text " for "
            , paraLink "Hasura" "https://hasura.io/"
            , text "."
            ]
            Nothing
        ]
            |> section "Public Content"
      , [ parcel "Free Movies" "https://freemovies.ltd/" "An aggregator for all the official free to watch movies on YouTube."
        , parcel "Restaurant Week" "https://tarbh.net/restaurant-week" "An excuse to play around with interactive maps."
        , parcel "Come to Gary" "https://tarbh.net/gary" "Gary is waiting."
        ]
            |> section "Nonsense"
      ]
        |> column [ spacing 80, width fill ]
    , links model.flip small
        |> when False

    --|> when (model.detail == Nothing)
    ]
        |> column
            --[ fork (width fill) (cappedWidth 750)
            [ width fill
            , height fill

            --, cappedHeight 750
            , spacing sp

            --, style "animation" "fadeIn 1.2s"
            ]
        |> el
            [ fork (width fill) (cappedWidth 750)
            , height fill
            , centerX
                |> whenAttr (not model.isMobile)
            , scrollbarY

            --, style "flex-basis" "auto"
            --, style "min-height" "auto"
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

            --, Background.gradient
            --{ angle = 0
            --, steps =
            --[ Element.rgb255 150 208 255
            --, white
            --]
            --}
            , height fill
            , width fill

            --, font
            , Font.family [ Font.typeface "Archivo" ]

            --, Background.color <| rgb255 150 250 250
            , Background.color <| rgb255 249 249 249
            ]


shadow : Attribute msg
shadow =
    --Border.shadow
    --{ offset = ( 3, 3 )
    --, blur = 0
    --, size = 0
    --, color = black
    --}
    inFront none


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
                    [ [ text "An end-to-end encrypted journal built on an "
                      , Element.newTabLink [ Font.underline ]
                            { url = "https://github.com/tarbh-engineering/journal"
                            , label = text "open source codebase"
                            }
                      , text "."
                      ]
                        |> paragraph []
                    ]

                Talk ->
                    [ [ text "A talk I performed at "
                      , Element.newTabLink [ Font.underline ]
                            { url = "https://hasura.io/events/hasura-con-2020/"
                            , label = text "Hasura Con 2020"
                            }
                      , text " talk on statically typed programming languages and how they can be used alongside GraphQL and Hasura."
                      ]
                        |> paragraph []
                    ]
    in
    [ newTabLink
        [ Element.mouseOver [ Font.color orange ]
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
                , height fill
                , width fill
                ]
                { src = img, description = "" }
                |> el
                    [ height <| px 169
                    , width <| px 300
                    , Background.color <| tan 0.5
                    , centerX
                    ]
            ]
                |> column [ spacing 10, width fill ]
        }

    --, [ text title ]
    --|> paragraph [ Font.bold, Font.center ]
    , body
        |> Element.textColumn [ width fill, spacing 10, Font.size 17 ]
    , Input.button
        [ Element.mouseOver [ Font.color orange ]
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
                    "Recent release"

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
        [ Element.mouseOver [ Font.color orange ]
        ]
        { onPress = Just <| SetDetail d
        , label =
            [ text emoj, text txt ]
                |> row [ spacing 20, Font.size (20 - adj) ]
        }


links : Bool -> Bool -> Element Msg
links flip small =
    let
        sp =
            if small then
                10

            else
                20

        icon =
            String.fromChar
                >> text
                >> el
                    [ Font.shadow { offset = ( 3, 3 ), blur = 0, color = black }
                    , Font.size
                        (30
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

    --, ( "more projects", "https://tarbh.engineering/", '📦' )
    ]
        |> List.map
            (\( title_, url, icon_ ) ->
                newTabLink
                    [ width fill
                    , cappedHeight 60
                    , shadow
                    , Background.color white
                    , Element.paddingXY 10 0
                    , Element.mouseOver
                        [ Background.color black
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
        |> (\xs ->
                let
                    em =
                        [ [ 'r', 'o', 'n', 'a', 'n', '_', 'm', 'c', 'c', 'a', 'b', 'e' ]
                        , [ 'p', 'm', '.', 'm', 'e' ]
                        ]
                            |> List.map String.fromList
                            |> String.join "@"
                in
                xs
                    ++ [ (if flip then
                            Element.link
                                [ centerX
                                , height fill
                                , Element.mouseOver
                                    [ Font.color orange ]
                                ]
                                { url = "mailto:" ++ em
                                , label =
                                    text em
                                        |> el [ centerY ]
                                }

                          else
                            Input.button
                                [ width fill
                                , height fill
                                ]
                                { onPress = Just Flip
                                , label =
                                    [ icon '📬', text "Get in touch" ]
                                        |> row
                                            [ centerX
                                            , spacing 20
                                            , Font.size 19
                                            ]
                                }
                         )
                            |> el
                                [ width fill
                                , cappedHeight 60
                                , shadow
                                , Background.color white
                                , Element.mouseOver
                                    [ Background.color black
                                    , Font.color white
                                    , Border.shadow
                                        { offset = ( 3, 3 )
                                        , blur = 0
                                        , size = 0
                                        , color = Element.rgb255 200 0 0
                                        }
                                    ]
                                    |> whenAttr (not flip)
                                ]
                       ]
           )
        |> column
            [ spacing sp
            , width fill
            , height fill
            ]


bounce txt url =
    newTabLink
        [ Font.underline
        , hover
        , Font.bold
        ]
        { url = url, label = item txt }


paraLink txt url =
    newTabLink
        [ Font.underline
        , hover
        ]
        { url = url, label = text txt }


header2 =
    text >> el [ Font.size 45, Font.bold ]


header =
    text
        >> el
            [ Font.size 45
            , Font.bold
            , Font.color white
            , Background.color black
            , paddingEach { left = 20, right = 20, top = 10, bottom = 10 }
            ]


item =
    text >> el [ Font.size 30 ]


section title elems =
    [ el [ Background.color black, height fill, width <| px 3 ] none
    , [ header title
      , [ --el [ height fill, width <| px 20 ] none
          elems
            |> List.map
                (\g ->
                    [ el [ height fill, width <| px 20 ] none
                    , g

                    --, el [ height fill, width <| px 20 ] none
                    ]
                        |> row [ width fill ]
                )
            |> List.intersperse
                (el
                    [ height <| px 3
                    , width fill
                    , Background.color black
                    ]
                    none
                )
            |> (\xs ->
                    xs
                        ++ [ el
                                [ height <| px 3
                                , width fill
                                , Background.color black
                                ]
                                none
                           ]
               )
            |> column [ spacing 30, width fill ]
        ]
            |> row [ width fill ]
      ]
        |> column [ spacing 20, width fill ]
    ]
        |> row [ width fill ]


parcel title url txt =
    parcelCore title url [ text txt ] Nothing


parcelTag title url txt tag =
    parcelCore title url [ text txt ] tag


parcelCore title url elems tag =
    [ [ [ bounce title url ]
            |> paragraph []
      , whenJust identity tag
            |> el [ alignTop ]
      ]
        |> row [ spaceEvenly, width fill ]
    , elems
        |> paragraph
            [ Font.family [ Font.typeface "Montserrat" ]
            , Font.size 20
            ]
    ]
        |> column [ spacing 20, width fill ]


solIcon =
    newTabLink [ hover ]
        { url = "https://solana.com/"
        , label =
            [ Img.solana 20
            , tagTxt "Solana"
            ]
                |> row
                    [ spacing 10
                    ]
        }


tagTxt =
    text
        >> el
            [ Font.family [ Font.typeface "Montserrat" ]
            , Font.bold
            ]


ethIcon =
    newTabLink [ hover ]
        { url = "https://ethereum.org/"
        , label =
            [ Img.ethereum 20
            , text "Ethereum"
            ]
                |> row [ spacing 10 ]
        }


viewTag : String -> String -> Element msg
viewTag txt lbl =
    [ text txt
        |> el
            [ padding 10
            , Font.bold
            , Background.color white
            , Font.color black
            ]
    , text lbl
        |> el [ paddingXY 15 0, Font.color white, centerY ]
        |> el [ height fill, Background.color black ]
    ]
        |> row [ Border.width 2, Border.color white ]


forkFn bool a b =
    if bool then
        a

    else
        b


fade : Element.Attr a b
fade =
    Element.alpha 0.7


shamrock =
    "url(\"data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='40' height='40' viewport='0 0 100 100' style='font-size:24px;'><text y='50%'>" ++ String.fromChar emj ++ "</text></svg>\"), auto"


emj =
    '🚀'


hover : Attribute msg
hover =
    Element.mouseOver [ fade ]
