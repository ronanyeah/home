module Img exposing (ethereum, solana, twitter)

import Element exposing (Element)
import Svg exposing (Svg, defs, g, linearGradient, stop, svg)
import Svg.Attributes exposing (clipPath, d, fill, gradientTransform, gradientUnits, height, id, offset, opacity, stopColor, viewBox, x1, x2, y1, y2)


twitter : Int -> Element msg
twitter size =
    svg
        [ viewBox "0 0 248 204"
        , height <| String.fromInt size
        ]
        [ Svg.path
            [ fill "#1d9bf0", d "m222 51.3.1 6.5c0 66.8-50.8 143.7-143.7 143.7A143 143 0 0 1 1 178.8a101.4 101.4 0 0 0 74.7-21 50.6 50.6 0 0 1-47.1-35 50.3 50.3 0 0 0 22.8-.8 50.5 50.5 0 0 1-40.5-49.5v-.7c7 4 14.8 6.1 22.9 6.3A50.6 50.6 0 0 1 18 10.7a143.3 143.3 0 0 0 104.1 52.8 50.5 50.5 0 0 1 86-46c11.4-2.3 22.2-6.5 32.1-12.3A50.7 50.7 0 0 1 218.1 33c10-1.2 19.8-3.9 29-8-6.7 10.2-15.3 19-25.2 26.2z" ]
            []
        ]
        |> wrap


solana : Int -> Element msg
solana size =
    svg
        [ viewBox "0 0 397.7 311.7"
        , height <| String.fromInt size
        ]
        [ linearGradient
            [ id "a"
            , x1 "360.8791"
            , x2 "141.213"
            , y1 "351.4553"
            , y2 "-69.2936"
            , gradientTransform "matrix(1 0 0 -1 0 314)"
            , gradientUnits "userSpaceOnUse"
            ]
            [ stop [ offset "0", stopColor "#00ffa3" ] [], stop [ offset "1", stopColor "#dc1fff" ] [] ]
        , Svg.path [ fill "url(#a)", d "M64.6 237.9c2.4-2.4 5.7-3.8 9.2-3.8h317.4c5.8 0 8.7 7 4.6 11.1l-62.7 62.7c-2.4 2.4-5.7 3.8-9.2 3.8H6.5c-5.8 0-8.7-7-4.6-11.1l62.7-62.7z" ] []
        , linearGradient
            [ id "b"
            , x1 "264.8291"
            , x2 "45.163"
            , y1 "401.6014"
            , y2 "-19.1475"
            , gradientTransform "matrix(1 0 0 -1 0 314)"
            , gradientUnits "userSpaceOnUse"
            ]
            [ stop [ offset "0", stopColor "#00ffa3" ] [], stop [ offset "1", stopColor "#dc1fff" ] [] ]
        , Svg.path [ fill "url(#b)", d "M64.6 3.8C67.1 1.4 70.4 0 73.8 0h317.4c5.8 0 8.7 7 4.6 11.1l-62.7 62.7c-2.4 2.4-5.7 3.8-9.2 3.8H6.5c-5.8 0-8.7-7-4.6-11.1L64.6 3.8z" ] []
        , linearGradient
            [ id "c", x1 "312.5484", x2 "92.8822", y1 "376.688", y2 "-44.061", gradientTransform "matrix(1 0 0 -1 0 314)", gradientUnits "userSpaceOnUse" ]
            [ stop [ offset "0", stopColor "#00ffa3" ] [], stop [ offset "1", stopColor "#dc1fff" ] [] ]
        , Svg.path [ fill "url(#c)", d "M333.1 120.1c-2.4-2.4-5.7-3.8-9.2-3.8H6.5c-5.8 0-8.7 7-4.6 11.1l62.7 62.7c2.4 2.4 5.7 3.8 9.2 3.8h317.4c5.8 0 8.7-7 4.6-11.1l-62.7-62.7z" ] []
        ]
        |> wrap


ethereum : Int -> Element msg
ethereum size =
    -- https://github.com/ethereum/ethereum-org-website/blob/dev/src/assets/assets/eth-diamond-black.svg
    svg
        [ viewBox "0 0 1920 1920"
        , height <| String.fromInt size
        ]
        [ Svg.path [ d "m959.8 730.9-539.8 245.4 539.8 319.1 539.9-319.1z", opacity ".6" ] []
        , Svg.path [ d "m420.2 976.3 539.8 319.1v-564.5-650.3z", opacity ".45" ] []
        , Svg.path [ d "m960 80.6v650.3 564.5l539.8-319.1z", opacity ".8" ] []
        , Svg.path [ d "m420 1078.7 539.8 760.7v-441.8z", opacity ".45" ] []
        , Svg.path [ d "m959.8 1397.6v441.8l540.2-760.7z", opacity ".8" ] []
        ]
        |> wrap


wrap : Svg msg -> Element msg
wrap =
    Element.html
        >> Element.el []
