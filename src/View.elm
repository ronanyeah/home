module View exposing (view)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Region as Region
import Helpers.View exposing (cappedWidth, style, whenAttr, whenJust)
import Html exposing (Html)
import Img
import Types exposing (..)


orange : Color
orange =
    Element.rgb255 255 140 0


grey : Color
grey =
    rgb255 235 235 235


white : Color
white =
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
    , [ [ parcelTag "Mineral"
            "https://mineral.supply/"
            "A proof-of-work currency that can be mined on any device."
            Product
            (Just suiIcon)
            (Just "https://github.com/ronanyeah/mineral")
        , parcelTag "Warp"
            "https://github.com/ronanyeah/warp"
            "An experimental wallet for the Solana Saga phone that interacts with the Sui blockchain."
            Product
            (Just suiIcon)
            (Just "https://github.com/ronanyeah/warp")
        , parcelTag "POW 💥"
            "https://pow.cafe/"
            "The world's first proof-of-work NFT."
            Product
            (Just solIcon)
            (Just "https://github.com/ronanyeah/pow-dapp")

        --, parcelTag "solanagames.gg"
        --"https://solanagames.gg/"
        --"All the games that are currently live on the Solana mainnet."
        --productCategory
        --(Just solIcon)
        --(Just "https://github.com/ronanyeah/solana-games-gg")
        --, parcelTag "Bonkopoly"
        --"https://bonkopoly.com"
        --"A secret game."
        --productCategory
        --(Just solIcon)
        --Nothing
        --, parcelCore "Arena"
        --"https://arena-staging.netlify.app/"
        --[ text "An onchain Rock/Paper/Scissors game. It was "
        --, paraLink "demoed live" "https://x.com/hackerhouses/status/1494998129779027973"
        --, text " at Hacker House Dubai 2022."
        --]
        --productCategory
        --(Just solIcon)
        --Nothing
        --, parcelCore "NestQuest"
        --"https://nestquest.io/"
        --[ text "An interactive tutorial and rewards program for the "
        --, paraLink "GooseFX DeFi platform" "https://app.goosefx.io/"
        --, text "."
        --]
        --productCategory
        --(Just solIcon)
        --(Just "https://github.com/GooseFX1/NestQuestWeb")
        , parcelCore "Terraloot"
            "https://terraloot.dev/"
            [ text "A Mars terraforming themed "
            , paraLink "ERC-721"
                "https://ethereum.org/en/developers/docs/standards/tokens/erc-721/"
            , text " NFT, inspired by "
            , paraLink "Loot" "https://www.lootproject.com/"
            , text "."
            ]
            Product
            (Just ethIcon)
            (Just "https://github.com/tarbh-engineering/terraloot-site")
        , parcelTag "Solana Connect"
            "https://www.npmjs.com/package/solana-connect"
            "A wallet select menu for Solana dApps."
            DevTool
            (Just solIcon)
            (Just "https://github.com/ronanyeah/solana-connect")
        , parcelTag "Beachwall"
            "https://beachwall.netlify.app/"
            "An onchain canvas, similar to /r/place."
            DevTool
            (Just solIcon)
            Nothing
        ]
            |> section "Web3"
      , [ parcelTag "Sui ZK Wallet"
            "https://sui-zk-wallet.netlify.app/"
            "Use social media login to create and interact with a Sui wallet."
            Demo
            (Just suiIcon)
            (Just "https://github.com/ronanyeah/sui-zk-wallet")
        , parcelCore "Elm + Webpack Example"
            "https://github.com/ronanyeah/elm-webpack"
            [ text "A template for starting an "
            , paraLink "Elm" "https://elm-lang.org/"
            , text " project. It supports live reload development, and production builds."
            ]
            DevContent
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
            DevContent
            Nothing
            Nothing
        , parcelTag "Rust Client Examples"
            "https://github.com/ronanyeah/solana-rust-examples"
            "A selection of scripts demonstrating how to use Rust to interact with the Solana blockchain."
            DevContent
            (Just solIcon)
            Nothing
        ]
            |> section "Open Source"
      , [ parcel "Follow the Types (2020)"
            "https://hasura.io/events/hasura-con-2020/talks/bugs-cant-hide-a-full-stack-exploration-in-type-safety/"
            "A talk I presented at HasuraCon 2020 about how strongly typed languages can be used alongside GraphQL to enforce full stack type safety."
            DevContent
        , parcelCore
            "Functional Programming in JavaScript (2017)"
            -- https://www.meetup.com/MancJS/events/242088443/
            "https://slides.com/ronanmccabe/fp-in-js"
            [ text "A talk on functional programming techniques in JS I presented at "
            , paraLink "MancJS" "https://www.meetup.com/mancjs/"
            , text "."
            ]
            DevContent
            Nothing
            Nothing
        , parcel
            "Service Worker FFI in Elm"
            "https://discourse.elm-lang.org/t/service-worker-ffi/6408/10"
            "Using service workers as an asynchronous escape hatch from the Elm runtime."
            DevContent
        ]
            |> section "Public Content"
      , [ parcel "Free Movies"
            "https://free-youtube-movies.netlify.app/"
            "An aggregator of the official free to watch movies on YouTube."
            Product
        , parcel "Restaurant Week"
            "https://tarbh.net/restaurant-week"
            "An excuse to play around with interactive maps."
            Product
        , parcel "Come to Gary"
            "https://tarbh.net/gary"
            "Gary is waiting."
            Product
        ]
            |> section "Nonsense"
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
            , Font.color black
            , Background.color white
            , paddingEach { left = 20, right = 20, top = 10, bottom = 10 }
            ]


item =
    text >> el [ Font.size 30 ]


section title elems =
    [ el [ Background.color white, height fill, width <| px 3 ] none
    , [ header title
      , [ elems
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
        ]
            |> row [ width fill ]
      ]
        |> column [ spacing 20, width fill ]
    ]
        |> row [ width fill ]


parcel : String -> String -> String -> Category -> Element msg
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
            ++ catToString category
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


catToString cat =
    case cat of
        Product ->
            "product"

        Demo ->
            "demo"

        DevContent ->
            "dev-content"

        DevTool ->
            "dev-tool"
