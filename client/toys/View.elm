module View exposing (..)

import Html.Attributes exposing (autoplay, href, style, src, attribute, class, classList, placeholder, value)
import Html.Events exposing (onClick, onInput)
import Html exposing (Html, button, h1, ul, li, a, div, text, strong, node, input)
import Dict exposing (Dict)
import Update exposing (..)
import Model exposing (Model)

-- VIEW

stylesheet : Html Msg
stylesheet =
    let
        tag =
            "link"

        attrs =
            [ attribute "rel" "stylesheet"
            , attribute "property" "stylesheet"
            , attribute "href" "/toys/index.css"
            ]

        children =
            []
    in
        node tag attrs children

cracks : Model -> Html Msg
cracks model =
    div []
        (stylesheet
            :: (List.map
                    (\y ->
                        div [ style [("", "")], class "row" ]
                            (List.map
                                (\x ->
                                    let
                                        xy =
                                            "x" ++ toString x ++ "y" ++ toString y
                                    in
                                        div
                                            [ style [("", "")]
                                            , classList
                                                [ ( "tile", True )
                                                , ( "black", Dict.member ( x, y ) model.cracks )
                                                ]
                                            , attribute "label" xy
                                            , onClick (Click ( x, y ))
                                            ]
                                            []
                                )
                                (List.range 1 100)
                            )
                    )
                    (List.reverse (List.range 1 100))
               )
        )

gifs : Model -> Html Msg
gifs model =
  let
    gifStyle : List ( String, String )
    gifStyle =
        [  ( "width", "12.4vw" )
        , ( "display", "relative" )
        ]


    inputStyle : List ( String, String )
    inputStyle =
        [ ( "height", "50px" )
        , ( "margin", "50px auto" )
        , ( "display", "block" )
        ]
  in
    div []
        (case List.length model.gifs.urls of
            0 ->
                [ input
                    [ value model.gifs.topic
                    , style inputStyle
                    , placeholder "topic"
                    , onInput UpdateTopic
                    ]
                    []
                ]

            _ ->
                (List.map
                    (\url -> Html.video [ style gifStyle, src url, autoplay True ] [])
                    model.gifs.urls
                )
        )

view : Model -> Html Msg
view model =
  case model.view of
    "#cracks" -> cracks model
    "#gifs" -> gifs model
    _ ->
      div []
        [ h1 [] [ text "Toys" ]
        , ul [] (List.map viewLink [ "cracks", "gifs" ])
        --, h1 [] [ text "History" ]
        --, ul [] (List.map viewLocation model.history)
        ]


viewLink : String -> Html Msg
viewLink name =
  li [] [ a [ href ("#" ++ name) ] [ text name ] ]


--viewLocation : Navigation.Location -> Html msg
--viewLocation location =
  --li [] [ text (location.pathname ++ location.hash) ]
