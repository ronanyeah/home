module Projects exposing (projects)

import Element exposing (..)
import Element.Font as Font
import Types exposing (..)


projects : List Project
projects =
    [ suiZKAirdrop
    , warp
    , cable
    , pow
    , mineral
    , rustSol
    , solanaConnect
    , terraloot
    , elmWebpack
    , storyWarz
    , elmPortGen
    , beachwall
    , suiZKWallet
    , rustGql
    , typeTalk
    , fpTalk
    , elmFFI
    , movies
    , restaurants
    , gary
    ]
        |> List.map
            (\p ->
                { p
                    | tags =
                        if
                            p.tags
                                |> List.any
                                    (\pt ->
                                        List.member pt
                                            [ SuiTag
                                            , EthTag
                                            , SolTag
                                            ]
                                    )
                        then
                            p.tags ++ [ Web3 ]

                        else
                            p.tags
                }
            )


mineral : Project
mineral =
    { title = "Mineral"
    , url = "https://mineral.supply/"

    ----https://x.com/MineralSupply/status/1789412797236863254
    , elems = [ text "A proof-of-work currency with a constant rate of output." ]
    , sourceLink = Just "https://github.com/ronanyeah/mineral"
    , imgSrc = Just "/screenshots/mineral.png"
    , tags = [ SuiTag ]
    }


pow : Project
pow =
    { title = "💥 POW"
    , url = "https://pow.cafe/"
    , elems = [ text "An NFT that requires grinding specific Solana wallet addresses in order to mint." ]
    , sourceLink = Just "https://github.com/ronanyeah/pow-dapp"
    , imgSrc = Just "/screenshots/pow-home.png"
    , tags = [ SolTag, NFT ]
    }


warp : Project
warp =
    { title = "Warp"
    , url = "https://x.com/ronanyeah/status/1824918964989739250"
    , elems = [ text "An experimental wallet for the Solana Saga phone that interacts with the Sui blockchain." ]
    , sourceLink = Just "https://github.com/ronanyeah/warp"
    , imgSrc = Just "/screenshots/warp.png"
    , tags = [ SuiTag, SolTag ]
    }


terraloot : Project
terraloot =
    { title = "Terraloot"
    , url = "https://terraloot.dev/"
    , elems =
        [ text "A Mars terraforming themed "
        , paraLink "ERC-721" "https://ethereum.org/en/developers/docs/standards/tokens/erc-721/"
        , text " NFT, inspired by "
        , paraLink "Loot" "https://www.lootproject.com/"
        , text "."
        ]
    , sourceLink = Just "https://github.com/tarbh-engineering/terraloot-site"
    , imgSrc = Just "/screenshots/terraloot.png"
    , tags = [ EthTag, NFT ]
    }


beachwall : Project
beachwall =
    { title = "Beachwall"
    , url = "https://beachwall.netlify.app/"
    , elems = [ text "An onchain canvas, similar to Reddit's /r/place." ]
    , sourceLink = Nothing
    , imgSrc = Just "/screenshots/beachwall.png"
    , tags = [ SolTag ]
    }


solanaConnect : Project
solanaConnect =
    { title = "Solana Connect"
    , url = "https://www.npmjs.com/package/solana-connect"
    , elems = [ text "A wallet select menu for Solana dApps." ]
    , sourceLink = Just "https://github.com/ronanyeah/solana-connect"
    , imgSrc = Just "/screenshots/sol-connect.png"
    , tags = [ SolTag, DevTooling ]
    }


movies : Project
movies =
    { title = "Free Movies"
    , url = "https://free-youtube-movies.netlify.app/"
    , elems = [ text "An aggregator of the official free-to-watch movies on YouTube." ]
    , sourceLink = Nothing
    , imgSrc = Nothing
    , tags = [ Nonsense ]
    }


restaurants : Project
restaurants =
    { title = "Restaurant Week"
    , url = "https://tarbh.net/restaurant-week"
    , elems = [ text "An excuse to play around with interactive maps." ]
    , sourceLink = Nothing
    , imgSrc = Just "/screenshots/restaurant-week.png"
    , tags = [ Nonsense ]
    }


gary : Project
gary =
    { title = "Come to Gary"
    , url = "https://tarbh.net/gary"
    , elems = [ text "Gary is waiting." ]
    , sourceLink = Nothing
    , imgSrc = Just "/screenshots/gary.png"
    , tags = [ Nonsense ]
    }


elmFFI : Project
elmFFI =
    { title = "Service Worker FFI in Elm"
    , url = "https://discourse.elm-lang.org/t/service-worker-ffi/6408"
    , elems =
        [ text
            "Using service workers as an asynchronous escape hatch from the Elm runtime."
        ]
    , sourceLink = Nothing
    , imgSrc = Nothing
    , tags = [ Elm, Demo ]
    }


fpTalk : Project
fpTalk =
    -- (2017)
    { title = "Functional Programming in JavaScript"

    --"https://www.meetup.com/MancJS/events/242088443/"
    , url = "https://slides.com/ronanmccabe/fp-in-js"
    , elems =
        [ text "A talk on functional programming techniques in JS I presented at "
        , paraLink "MancJS" "https://www.meetup.com/mancjs/"
        , text "."
        ]
    , sourceLink = Nothing
    , imgSrc = Nothing
    , tags = [ Demo, TypeTheory ]
    }


typeTalk : Project
typeTalk =
    { title = "Follow the Types"
    , url = "https://hasura.io/events/hasura-con-2020/talks/bugs-cant-hide-a-full-stack-exploration-in-type-safety/"
    , elems =
        [ text
            "A talk I presented at HasuraCon 2020 about how strongly typed languages can be used alongside GraphQL to enforce full stack type safety."
        ]
    , sourceLink = Nothing
    , imgSrc = Nothing
    , tags = [ Demo, TypeTheory ]
    }


rustSol : Project
rustSol =
    { title = "Solana Rust Examples"
    , url = "https://github.com/ronanyeah/solana-rust-examples"
    , elems =
        [ text
            "A selection of scripts demonstrating how to use Rust to interact with the Solana blockchain."
        ]
    , sourceLink = Nothing
    , imgSrc = Just "/screenshots/repo.png"
    , tags = [ Rust, SolTag, Demo ]
    }


rustGql : Project
rustGql =
    { title = "Rust + Async + GraphQL Example"
    , url = "https://github.com/ronanyeah/rust-hasura"
    , elems =
        [ text "An example of a Rust server that functions as a "
        , paraLink "remote schema" "https://hasura.io/docs/latest/graphql/core/remote-schemas/index/"
        , text " for "
        , paraLink "Hasura" "https://hasura.io/"
        , text "."
        ]
    , sourceLink = Nothing
    , imgSrc = Nothing
    , tags = [ Rust, Demo ]
    }


elmWebpack : Project
elmWebpack =
    { title = "Elm + Webpack Example"
    , url = "https://github.com/ronanyeah/elm-webpack"
    , elems =
        [ text "A template for starting an "
        , paraLink "Elm" "https://elm-lang.org/"
        , text " project. It supports live reload development, and production builds."
        ]
    , sourceLink = Nothing
    , imgSrc = Nothing
    , tags = [ Elm, Demo ]
    }


suiZKWallet : Project
suiZKWallet =
    { title = "Sui ZK Wallet"
    , url = "https://sui-zk-wallet.netlify.app/"
    , elems =
        [ text "Use social media login to create and interact with a Sui wallet."
        ]
    , sourceLink = Just "https://github.com/ronanyeah/sui-zk-wallet"
    , imgSrc = Nothing
    , tags = [ SuiTag, ZK, Demo ]
    }


cable : Project
cable =
    { title = "Cable"
    , url = "https://cable.walrus.site/"
    , elems =
        [ text "End-to-end encrypted wallet-to-wallet messaging, backed by Walrus storage."
        ]
    , sourceLink = Just "https://github.com/ronanyeah/cable"
    , imgSrc = Just "/screenshots/cable.png"
    , tags = [ SuiTag, Encryption ]
    }


storyWarz : Project
storyWarz =
    { title = "Story Warz"
    , url = "https://story-warz.netlify.app/"
    , elems =
        [ text "An at-home version of the YouTube game show 'Story Warz'. Built largely using the Windsurf AI IDE."
        ]
    , sourceLink = Nothing
    , imgSrc = Nothing
    , tags = [ Nonsense ]
    }


elmPortGen : Project
elmPortGen =
    { title = "elm-port-gen"
    , url = "https://github.com/ronanyeah/elm-port-gen"
    , elems =
        [ text "A CLI for generating TypeScript bindings from Elm type definitions."
        ]
    , sourceLink = Nothing
    , imgSrc = Just "/screenshots/repo.png"
    , tags = [ Elm, DevTooling ]
    }


suiZKAirdrop : Project
suiZKAirdrop =
    { title = "Sui ZK Airdrop"
    , url = "https://github.com/ronanyeah/sui-zk-airdrop"
    , elems =
        [ text "A proof-of-concept of using ZK proofs to verify whitelist inclusion onchain."
        ]
    , sourceLink = Nothing
    , imgSrc = Just "/screenshots/repo.png"
    , tags = [ SuiTag, ZK, Demo ]
    }


paraLink : String -> String -> Element msg
paraLink txt url =
    newTabLink
        [ Font.underline
        , Element.mouseOver [ Element.alpha 0.7 ]
        ]
        { url = url, label = text txt }
