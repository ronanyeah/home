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
import Types exposing (Detail(..), Model, Msg(..))


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


monospaceFont =
    Font.family [ Font.monospace ]


textFont =
    Font.family [ Font.typeface "Montserrat Variable" ]


mainFont =
    Font.family [ Font.typeface "Archivo Variable" ]


titleFont =
    Font.family [ Font.typeface "IBM Plex Mono" ]


view : Model -> Html Msg
view model =
    let
        big =
            model.size.width >= 800

        small =
            model.size.width < 375 || model.size.height < 800

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
            , width fill
            , height fill
            , Background.color <| rgb255 170 170 170
            , style "cursor" shamrock
            ]
            --{ src = "/new2.svg", description = "" }
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

                    --, [ text "github.com/"
                    --, text "ronanyeah"
                    --]
                    --|> column [ centerY, Font.size 17 ]
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

                    --, [ text "x.com/"
                    --, text "ronanyeah"
                    --]
                    --|> column [ centerY, Font.size 17 ]
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
    , let
        productCategory =
            "product"

        demoCat =
            "demo"

        devCat =
            "dev-content"

        devToolCat =
            "dev-tool"
      in
      [ [ parcelTag "solanagames.gg"
            "https://solanagames.gg/"
            "All the games that are currently live on the Solana mainnet."
            productCategory
            (Just solIcon)
            (Just "https://github.com/ronanyeah/solana-games-gg")
        , parcelTag "Sui ZK Wallet"
            "https://sui-zk-wallet.netlify.app/"
            "Use social media login to create and interact with a Sui wallet."
            demoCat
            (Just suiIcon)
            (Just "https://github.com/ronanyeah/sui-zk-wallet")
        , parcelTag "Bonkopoly"
            "https://bonkopoly.com"
            "A secret game."
            productCategory
            (Just solIcon)
            Nothing
        , parcelTag "Solana Connect"
            "https://www.npmjs.com/package/solana-connect"
            "A wallet select menu for Solana dApps."
            devToolCat
            (Just solIcon)
            (Just "https://github.com/ronanyeah/solana-connect")
        , parcelTag "Rust Client Examples"
            "https://github.com/ronanyeah/solana-rust-examples"
            "A selection of scripts demonstrating how to use Rust to interact with the Solana blockchain."
            devCat
            (Just solIcon)
            Nothing
        , parcelCore "Arena"
            "https://arena-staging.netlify.app/"
            [ text "An onchain Rock/Paper/Scissors game. It was "
            , paraLink "demoed live" "https://x.com/hackerhouses/status/1494998129779027973"
            , text " at Hacker House Dubai 2022."
            ]
            productCategory
            (Just solIcon)
            Nothing
        , parcelCore "NestQuest"
            "https://nestquest.io/"
            [ text "An interactive tutorial and rewards program for the "
            , paraLink "GooseFX DeFi platform" "https://app.goosefx.io/"
            , text "."
            ]
            productCategory
            (Just solIcon)
            (Just "https://github.com/GooseFX1/NestQuestWeb")
        , parcelCore "Terraloot"
            "https://terraloot.netlify.app/"
            [ text "A Mars terraforming themed "
            , paraLink "ERC-721"
                "https://ethereum.org/en/developers/docs/standards/tokens/erc-721/"
            , text " NFT, inspired by "
            , paraLink "Loot" "https://www.lootproject.com/"
            , text "."
            ]
            productCategory
            (Just ethIcon)
            Nothing
        ]
            |> section "Web3"
      , [ parcel "Follow the Types (2020)"
            "https://hasura.io/events/hasura-con-2020/talks/bugs-cant-hide-a-full-stack-exploration-in-type-safety/"
            "A talk I presented at HasuraCon 2020 about how strongly typed languages can be used alongside GraphQL to enforce full stack type safety."
            devCat
        , parcelCore
            "Functional Programming in JavaScript (2017)"
            -- https://www.meetup.com/MancJS/events/242088443/
            "https://slides.com/ronanmccabe/fp-in-js"
            [ text "A talk on functional programming techniques in JS I presented at "
            , paraLink "MancJS" "https://www.meetup.com/mancjs/"
            , text "."
            ]
            devCat
            Nothing
            Nothing
        , parcelCore "Elm + Webpack Example"
            "https://github.com/ronanyeah/elm-webpack"
            [ text "A template for starting an "
            , paraLink "Elm" "https://elm-lang.org/"
            , text " project. It supports live reload development, and production builds."
            ]
            devCat
            Nothing
            Nothing
        , parcelCore "Rust + Async + GraphQL Example"
            "https://github.com/ronanyeah/rust-hasura"
            [ text "An example of a Rust server that functions as a "
            , paraLink "remote schema" "https://hasura.io/docs/latest/graphql/core/remote-schemas/index/"
            , text " for "
            , paraLink "Hasura" "https://hasura.io/"
            , text "."
            ]
            devCat
            Nothing
            Nothing
        ]
            |> section "Public Content"
      , [ parcel "Free Movies"
            "https://free-youtube-movies.netlify.app/"
            "An aggregator of the official free to watch movies on YouTube."
            productCategory
        , parcel "Restaurant Week"
            "https://tarbh.net/restaurant-week"
            "An excuse to play around with interactive maps."
            productCategory
        , parcel "Come to Gary"
            "https://tarbh.net/gary"
            "Gary is waiting."
            productCategory
        ]
            |> section "Nonsense"
      ]
        |> column [ spacing 80, width fill ]
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
            , mainFont

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


viewEmail flip small =
    let
        em =
            [ [ 'r', 'o', 'n', 'a', 'n', '_', 'm', 'c', 'c', 'a', 'b', 'e' ]
            , [ 'p', 'm', '.', 'm', 'e' ]
            ]
                |> List.map String.fromList
                |> String.join "@"

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
    (if flip then
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


parcel title url txt category =
    parcelCore title url [ text txt ] category Nothing Nothing


parcelTag title url txt category =
    parcelCore title url [ text txt ] category


parcelCore title url elems category tag sourceLink =
    [ [ [ [ bounce title url ]
            |> paragraph []
        , whenJust identity tag
            |> el [ alignTop ]
        ]
            |> row [ spaceEvenly, width fill ]
      , elems
            |> paragraph
                [ textFont
                , Font.size 20
                ]
      ]
        |> column [ spacing 20, width fill ]
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
      , "--"
            ++ category
            |> text
            |> el [ Font.italic, alignRight, monospaceFont ]
      ]
        |> row [ width fill ]
    ]
        |> column [ spacing 15, width fill ]


solIcon =
    bubbleTag "https://solana.com/" "Solana" Img.solana 17


suiIcon =
    bubbleTag "https://sui.io/" "Sui" Img.sui 17


bubbleTag url txt img size =
    newTabLink
        [ hover
        , Background.color <| rgb255 220 220 220
        , Border.rounded 20
        , paddingXY 13 8
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


tagTxt =
    text
        >> el
            [ textFont
            , Font.bold
            ]


ethIcon =
    bubbleTag "https://ethereum.org/" "Ethereum" Img.ethereum 17


forkFn bool a b =
    if bool then
        a

    else
        b


fade : Element.Attr a b
fade =
    Element.alpha 0.7


shamrock =
    "url(\"data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='40' height='40' viewport='0 0 100 100' style='font-size:24px;'><text y='50%'>" ++ shm ++ "</text></svg>\"), auto"


shm =
    "☘️"


hover : Attribute msg
hover =
    Element.mouseOver [ fade ]
