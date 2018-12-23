module Image exposing (tip)

import Element exposing (Element)
import Svg exposing (svg)
import Svg.Attributes exposing (d, fill, viewBox)


tip : Element msg
tip =
    svg [ viewBox "0 0 495.04 445.44" ]
        [ Svg.path
            [ fill "#ffa28d"
            , d "M15.36 403.84V126.72l288 123.2v30.72z"
            ]
            []
        , Svg.path
            [ fill "#2d2220"
            , d "M0 445.44l485.44-208c6.08-2.56 9.6-8.32 9.6-14.72s-3.52-12.16-9.6-14.72L0 0v445.44V0zM303.36 164.8v115.84l-288 123.232V41.6z"
            ]
            []
        , Svg.path
            [ fill "#fff"
            , d "M17.178 42.795c.505 0 65.103 27.451 143.55 61.002L303.36 164.8v83.993l-96.621-41.297a192462.829 192462.829 0 0 1-143.224-61.277l-46.602-19.978-.327-41.723c-.18-22.948.086-41.723.592-41.723z"
            ]
            []
        ]
        |> Element.html
