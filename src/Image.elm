module Image exposing (tip)

import Element exposing (Element)
import Svg exposing (defs, metadata, svg)
import Svg.Attributes exposing (..)


tip : Element msg
tip =
    svg
        [ height "445.44"
        , viewBox "0 0 495.04 445.44"
        , version "1.1"
        , width "495.04001"
        ]
        [ metadata [] []
        , defs [] []
        , Svg.path [ d "M 15.36,403.84 V 126.72 l 288,123.2 v 30.72 z", style "fill:#ffa28d" ] []
        , Svg.path [ d "m 0,445.44 485.44,-208 c 6.08,-2.56 9.6,-8.32 9.6,-14.72 0,-6.4 -3.52,-12.16 -9.6,-14.72 L 0,0 V 445.44 0 Z" ] []
        , Svg.path [ d "M 303.36,164.8 v 115.84 l -288,123.232 V 41.600003 Z", style "fill:#2d2220" ] []
        , Svg.path
            [ style "fill:#ffffff;stroke-width:1.24271846"
            , d "m 17.17772,42.794923 c 0.50532,0 65.10304,27.45114 143.55052,61.002537 L 303.36,164.8 v 41.99666 41.99668 L 206.73864,207.49572 C 153.5969,184.78204 89.14642,157.20768 63.51534,146.21934 L 16.9134,126.24056 16.5862,84.517743 c -0.18,-22.94756 0.0862,-41.72282 0.59152,-41.72282 z"
            ]
            []
        ]
        |> Element.html
