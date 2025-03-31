module Projects exposing (..)

import Element exposing (..)
import Element.Font as Font
import Types exposing (..)


mineral : Project
mineral =
    { title = "Mineral"
    , url = "https://mineral.supply/"
    , elems = [ text "A proof-of-work currency that can be mined on any device." ]
    , category = Product
    , tag = Just Sui
    , sourceLink = Just "https://github.com/ronanyeah/mineral"

    ----https://x.com/MineralSupply/status/1789412797236863254
    , imgSrc = Just "/screenshots/mineral.png"
    }


pow : Project
pow =
    { title = "POW "
    , url = "https://pow.cafe/"
    , elems = [ text "The world's first proof-of-work NFT." ]
    , category = Product
    , tag = Just Solana
    , sourceLink = Just "https://github.com/ronanyeah/pow-dapp"
    , imgSrc = Just "/screenshots/pow-home.png"
    }


warp : Project
warp =
    { title = "Warp"
    , url = "https://github.com/ronanyeah/warp"
    , elems = [ text "An experimental wallet for the Solana Saga phone that interacts with the Sui blockchain." ]
    , category = Product
    , tag = Just Sui
    , sourceLink = Just "https://github.com/ronanyeah/warp"
    , imgSrc = Just "/screenshots/warp.png"
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
    , category = Product
    , tag = Just Ethereum
    , sourceLink = Just "https://github.com/tarbh-engineering/terraloot-site"
    , imgSrc = Just "/screenshots/terraloot.png"
    }


beachwall : Project
beachwall =
    { title = "Beachwall"
    , url = "https://beachwall.netlify.app/"
    , elems = [ text "An onchain canvas, similar to /r/place." ]
    , category = Product
    , tag = Just Solana
    , sourceLink = Nothing
    , imgSrc = Nothing
    }


solanaConnect : Project
solanaConnect =
    { title = "Solana Connect"
    , url = "https://www.npmjs.com/package/solana-connect"
    , elems = [ text "A wallet select menu for Solana dApps." ]
    , category = DevTool
    , tag = Just Solana
    , sourceLink = Just "https://github.com/ronanyeah/solana-connect"
    , imgSrc = Nothing
    }


movies : Project
movies =
    { title = "Free Movies"
    , url = "https://free-youtube-movies.netlify.app/"
    , elems = [ text "An aggregator of the official free-to-watch movies on YouTube." ]
    , category = Product
    , tag = Nothing
    , sourceLink = Nothing
    , imgSrc = Nothing
    }


restaurants : Project
restaurants =
    { title = "Restaurant Week"
    , url = "https://tarbh.net/restaurant-week"
    , elems = [ text "An excuse to play around with interactive maps." ]
    , category = Product
    , tag = Nothing
    , sourceLink = Nothing
    , imgSrc = Nothing
    }


gary : Project
gary =
    { title = "Come to Gary"
    , url = "https://tarbh.net/gary"
    , elems = [ text "Gary is waiting." ]
    , category = Product
    , tag = Nothing
    , sourceLink = Nothing
    , imgSrc = Nothing
    }


elmFFI : Project
elmFFI =
    { title = "Service Worker FFI in Elm"
    , url = "https://discourse.elm-lang.org/t/service-worker-ffi/6408/10"
    , elems =
        [ text
            "Using service workers as an asynchronous escape hatch from the Elm runtime."
        ]
    , category = DevContent
    , tag = Nothing
    , sourceLink = Nothing
    , imgSrc = Nothing
    }


fpTalk : Project
fpTalk =
    { title = "Functional Programming in JavaScript (2017)"

    --"https://slides.com/ronanmccabe/fp-in-js"
    , url = "https://www.meetup.com/MancJS/events/242088443/"
    , elems =
        [ text "A talk on functional programming techniques in JS I presented at "
        , paraLink "MancJS" "https://www.meetup.com/mancjs/"
        , text "."
        ]
    , category = DevContent
    , tag = Nothing
    , sourceLink = Nothing
    , imgSrc = Nothing
    }


typeTalk : Project
typeTalk =
    { title = "Follow the Types (2020)"
    , url = "https://hasura.io/events/hasura-con-2020/talks/bugs-cant-hide-a-full-stack-exploration-in-type-safety/"
    , elems =
        [ text
            "A talk I presented at HasuraCon 2020 about how strongly typed languages can be used alongside GraphQL to enforce full stack type safety."
        ]
    , category = DevContent
    , tag = Nothing
    , sourceLink = Nothing
    , imgSrc = Nothing
    }


rustSol : Project
rustSol =
    { title = "Rust Client Examples"
    , url = "https://github.com/ronanyeah/solana-rust-examples"
    , elems =
        [ text
            "A selection of scripts demonstrating how to use Rust to interact with the Solana blockchain."
        ]
    , category = DevContent
    , tag = Just Solana
    , sourceLink = Nothing
    , imgSrc = Nothing
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
    , category = DevContent
    , tag = Nothing
    , sourceLink = Nothing
    , imgSrc = Nothing
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
    , category = DevContent
    , tag = Nothing
    , sourceLink = Nothing
    , imgSrc = Nothing
    }


suiZK : Project
suiZK =
    { title = "Sui ZK Wallet"
    , url = "https://sui-zk-wallet.netlify.app/"
    , elems =
        [ text "Use social media login to create and interact with a Sui wallet."
        ]
    , category = Demo
    , tag = Just Sui
    , sourceLink = Just "https://github.com/ronanyeah/sui-zk-wallet"
    , imgSrc = Nothing
    }


paraLink : String -> String -> Element msg
paraLink txt url =
    newTabLink
        [ Font.underline
        , Element.mouseOver [ Element.alpha 0.7 ]
        ]
        { url = url, label = text txt }



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
--
--
--, parcelCore "Arena"
--"https://arena-staging.netlify.app/"
--[ text "An onchain Rock/Paper/Scissors game. It was "
--, paraLink "demoed live" "https://x.com/hackerhouses/status/1494998129779027973"
--, text " at Hacker House Dubai 2022."
--]
--productCategory
--(Just solIcon)
--Nothing
--
--
--, parcelCore "NestQuest"
--"https://nestquest.io/"
--[ text "An interactive tutorial and rewards program for the "
--, paraLink "GooseFX DeFi platform" "https://app.goosefx.io/"
--, text "."
--]
--productCategory
--(Just solIcon)
--(Just "https://github.com/GooseFX1/NestQuestWeb")
