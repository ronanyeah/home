module View exposing (view)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region
import Helpers.View exposing (cappedWidth, style, when, whenAttr, whenJust)
import Html exposing (Html)
import Html.Attributes
import Img
import Maybe.Extra exposing (unwrap)
import Projects exposing (projects)
import Types exposing (..)


rightWidth : Int
rightWidth =
    450


view : Model -> Html Msg
view model =
    let
        big =
            model.size.width >= 800

        small =
            model.size.width < 375 || model.size.height < 800

        sp =
            20

        fork =
            forkFn model.isMobile

        projectsElem =
            model.selectedProject
                |> unwrap
                    (viewProjects model)
                    (viewProject model.isMobile)
    in
    [ [ [ [ image
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
              [ image
                    [ height <| px n
                    , width <| px n
                    ]
                    { src = "/icons/github.png", description = "" }
                    |> linkOut "https://github.com/ronanyeah" []
              , image [ width <| px (n + 10) ]
                    { description = ""
                    , src = Img.telegram
                    }
                    |> linkOut "https://t.me/ronanyeah" []
              , Img.x (n - 5)
                    |> linkOut "https://x.com/ronanyeah" []
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
      , [ [ text "Usually building apps, bots, games and experiments across the stack."
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
      , viewTags model
      , projectsElem
            |> when model.isMobile
      ]
        |> column
            [ height fill
            , width fill
            , spacing sp
            ]
    , projectsElem
        |> when (not model.isMobile)
    ]
        |> row
            [ fork (width fill) (cappedWidth 1150)
            , height (minimum 0 fill)
            , spacing 40
            , centerX
                |> whenAttr (not model.isMobile)
            , fork 20 40
                |> padding
            , scrollbarY
                |> whenAttr model.isMobile
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


viewProject : Bool -> Project -> Element Msg
viewProject isMobile project =
    [ text "<< Back"
        |> btn (Just (SetProject Nothing))
            [ Font.underline, alignRight, Font.size 22, monospaceFont ]
    , [ [ [ [ text project.title
                |> linkOut project.url
                    [ Font.underline
                    , Font.bold
                    , Font.size 45
                    ]
            ]
                |> paragraph []
          , (if List.member SuiTag project.tags then
                Just suiIcon

             else if List.member SolTag project.tags then
                Just solIcon

             else if List.member EthTag project.tags then
                Just ethIcon

             else
                Nothing
            )
                |> whenJust identity
                |> el [ alignTop ]
          ]
            |> row [ spaceEvenly, width fill ]
        , project.elems
            |> paragraph
                [ textFont
                , Font.size 20
                ]
        ]
            |> column [ spacing 30, width fill ]
      , [ ellipsisText project.url
            |> linkOut project.url
                [ Font.underline
                , monospaceFont
                , Font.italic
                , Font.size 17
                ]
        , project.sourceLink
            |> whenJust
                (\code ->
                    text "source code"
                        |> linkOut code
                            [ Font.underline
                            , monospaceFont
                            , Font.italic
                            , Font.size 17
                            ]
                )
        ]
            |> column [ width fill, spacing 10 ]
      , formatTags project.tags
            |> wrappedRow
                [ spacing 10
                , Font.size 20
                , alignRight
                , Font.underline
                ]
      , project.imgSrc
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
        |> column
            [ spacing 30
            , height (minimum 0 fill)
                |> whenAttr (not isMobile)
            , Border.width 1
            , padding 10
            , scrollbarY
                |> whenAttr (not isMobile)
            ]
    ]
        |> column
            [ height fill
            , if isMobile then
                width fill

              else
                cappedWidth rightWidth
            , spacing 20
            ]


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
        , Background.color white
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


btn : Maybe msg -> List (Attribute msg) -> Element msg -> Element msg
btn msg attrs elem =
    Input.button
        ((hover
            |> whenAttr (msg /= Nothing)
         )
            :: attrs
        )
        { onPress = msg
        , label = elem
        }


grey : Color
grey =
    rgb255 235 235 235


white : Color
white =
    rgb255 225 225 225


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


tags : List Tag
tags =
    [ SuiTag
    , SolTag
    , Rust
    , Elm
    , EthTag
    , Web3
    , DevTooling
    , Demo
    , Encryption
    , ZK
    , TypeTheory
    , Nonsense
    ]


viewTags : Model -> Element Msg
viewTags model =
    let
        otherTags =
            filterProjects model.selectedTags
                |> List.concatMap .tags
    in
    [ [ text "Tags"
            |> el [ Font.bold, monospaceFont ]
      , text ("Clear [" ++ String.fromInt (List.length model.selectedTags) ++ "]")
            |> btn (Just ClearTags)
                [ Font.underline, alignRight ]
            |> when (not (List.isEmpty model.selectedTags))
      ]
        |> row [ width fill ]
    , tags
        |> List.map
            (\tag ->
                let
                    msg =
                        if List.isEmpty model.selectedTags then
                            Just (SelectTag tag)

                        else if List.member tag otherTags then
                            Just (SelectTag tag)

                        else
                            Nothing

                    isSelected =
                        List.member tag model.selectedTags
                in
                tagToElem tag
                    |> btn msg
                        [ Border.width 1
                        , fade
                            |> whenAttr (msg == Nothing)
                        , Background.color white
                            |> whenAttr isSelected
                        , Font.color black
                            |> whenAttr isSelected
                        ]
            )
        |> wrappedRow [ spacing 10, width fill ]
    ]
        |> column [ spacing 10, height fill, width fill ]


viewProjects : Model -> Element Msg
viewProjects model =
    let
        filteredProjects =
            filterProjects model.selectedTags
    in
    [ text ("Projects [" ++ String.fromInt (List.length filteredProjects) ++ "]")
        |> el [ Font.bold, alignRight, Font.size 30, monospaceFont ]
    , filteredProjects
        |> List.map
            (\project ->
                let
                    projSp =
                        15
                in
                [ [ [ [ text project.title ]
                        |> paragraph
                            [ Font.size 20
                            , Font.bold
                            ]
                    , project.elems
                        |> paragraph
                            [ Font.size 18
                            ]
                    ]
                        |> column [ spacing projSp, width fill ]
                  , project.imgSrc
                        |> whenJust
                            (\img ->
                                image
                                    [ width fill
                                    , height fill
                                    ]
                                    { src = img, description = "" }
                                    |> el
                                        [ width <| px 75
                                        , height <| px 75
                                        , Border.width 1
                                        , clip
                                        , alignTop
                                        ]
                            )
                  ]
                    |> row [ width fill, spacing 10 ]
                , formatTags project.tags
                    |> row
                        [ spacing 10
                        , Font.size 17
                        , alignRight
                        , Font.underline
                        ]
                ]
                    |> column
                        [ spacing projSp
                        , width fill
                        , Border.width 1
                        , padding 10
                        , mouseOver
                            [ Background.color white
                            , Font.color black
                            ]
                        ]
                    |> btn (Just <| SetProject (Just project))
                        [ width fill ]
            )
        |> column
            [ width fill
            , spacing 10
            , scrollbarY
                |> whenAttr (not model.isMobile)
            , height (minimum 0 fill)
            ]
    ]
        |> column
            [ height fill
            , if model.isMobile then
                width fill

              else
                cappedWidth rightWidth
            , spacing 10
            ]


tagToString : Tag -> String
tagToString tag =
    case tag of
        Web3 ->
            "Web3"

        SuiTag ->
            "Sui"

        EthTag ->
            "Ethereum"

        SolTag ->
            "Solana"

        Elm ->
            "Elm"

        Rust ->
            "Rust"

        DevTooling ->
            "Developer Tools"

        Nonsense ->
            "Nonsense"

        TypeTheory ->
            "Type Theory"

        Encryption ->
            "Encryption"

        ZK ->
            "ZK"

        Demo ->
            "Demo"


tagToLogo : Tag -> Maybe (Element msg)
tagToLogo tag =
    case tag of
        Web3 ->
            Nothing

        SuiTag ->
            Just (Img.sui 17)

        EthTag ->
            Just (Img.ethereum 17)

        SolTag ->
            Just (Img.solana 17)

        Elm ->
            Just
                (image [ height <| px 17 ]
                    { src = "/icons/elm.svg"
                    , description = ""
                    }
                )

        Rust ->
            Just
                (image [ height <| px 17 ]
                    { src = "/icons/rust.svg"
                    , description = ""
                    }
                )

        DevTooling ->
            Nothing

        Nonsense ->
            Nothing

        TypeTheory ->
            Nothing

        Encryption ->
            Nothing

        ZK ->
            Nothing

        Demo ->
            Nothing


tagToElem : Tag -> Element msg
tagToElem tag =
    [ tagToLogo tag
        |> whenJust
            (\icon ->
                icon
                    |> el
                        [ Background.color white
                        , padding 10
                        , height fill
                        ]
            )
    , tagToString tag
        |> text
        |> el
            [ padding 10
            , monospaceFont
            ]
    ]
        |> row []


formatTags : List Tag -> List (Element msg)
formatTags =
    List.map (tagToString >> (++) "#" >> text)


ellipsisText : String -> Element msg
ellipsisText txt =
    Html.div
        [ Html.Attributes.style "overflow" "hidden"
        , Html.Attributes.style "text-overflow" "ellipsis"

        --, Html.Attributes.style "white-space" "nowrap"
        --, Html.Attributes.style "display" "table-cell"
        , Html.Attributes.style "line-height" "1.2"
        , Html.Attributes.title txt
        ]
        [ Html.text txt
        ]
        |> Element.html
        |> el
            [ width fill
            , style "table-layout" "fixed"
            , style "display" "table"
            ]


filterProjects : List Tag -> List Project
filterProjects selectedTags =
    projects
        |> (if List.isEmpty selectedTags then
                identity

            else
                List.filter
                    (\project ->
                        selectedTags
                            |> List.all
                                (\t ->
                                    List.member t project.tags
                                )
                    )
           )
