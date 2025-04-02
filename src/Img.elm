module Img exposing (..)

import Element exposing (Element)
import Svg exposing (Svg, linearGradient, path, stop, svg)
import Svg.Attributes exposing (d, fill, gradientTransform, gradientUnits, height, id, offset, opacity, stopColor, viewBox, x1, x2, y1, y2)


x : Int -> Element msg
x n =
    svg
        [ Svg.Attributes.width <| String.fromInt n
        , Svg.Attributes.viewBox "0 0 1200 1227"
        , Svg.Attributes.fill "none"
        ]
        [ Svg.path
            [ Svg.Attributes.d "M714.163 519.284L1160.89 0H1055.03L667.137 450.887L357.328 0H0L468.492 681.821L0 1226.37H105.866L515.491 750.218L842.672 1226.37H1200L714.137 519.284H714.163ZM569.165 687.828L521.697 619.934L144.011 79.6944H306.615L611.412 515.685L658.88 583.579L1055.08 1150.3H892.476L569.165 687.854V687.828Z"
            , Svg.Attributes.fill "black"
            ]
            []
        ]
        |> wrap


sui : Int -> Element msg
sui n =
    svg
        [ Svg.Attributes.width <| String.fromInt n
        , height <| String.fromInt n
        , Svg.Attributes.viewBox "0 0 783 1000"
        , Svg.Attributes.fill "none"
        ]
        [ path
            [ Svg.Attributes.fillRule "evenodd"
            , Svg.Attributes.clipRule "evenodd"
            , Svg.Attributes.d "M626.01 417.062L625.992 417.106C666.789 468.26 691.169 533.051 691.169 603.521C691.169 675.039 666.058 740.709 624.161 792.21L620.553 796.644L619.597 791.009C618.784 786.216 617.827 781.378 616.717 776.5C595.749 684.372 527.433 605.373 414.993 541.408C339.064 498.332 295.602 446.463 284.191 387.53C276.822 349.422 282.301 311.145 292.889 278.359C303.474 245.584 319.22 218.124 332.597 201.592L332.606 201.581L376.345 148.097C384.016 138.718 398.371 138.718 406.042 148.097L626.01 417.062ZM695.192 363.627L695.2 363.607L402.029 5.1334C396.432 -1.71113 385.952 -1.71113 380.354 5.1334L87.1804 363.611L87.1885 363.631L86.2346 364.814C32.285 431.76 0 516.837 0 609.449C0 825.141 175.139 1000 391.192 1000C607.245 1000 782.383 825.141 782.383 609.449C782.383 516.838 750.098 431.761 696.149 364.814L695.192 363.627ZM157.328 415.907L157.34 415.893L183.562 383.828L184.355 389.748C184.983 394.437 185.744 399.15 186.647 403.884C203.614 492.906 264.225 567.135 365.56 624.624C453.645 674.757 504.93 732.405 519.708 795.63C525.873 822.016 526.972 847.977 524.302 870.675L524.136 872.079L522.866 872.7C483.11 892.122 438.418 903.023 391.183 903.023C225.509 903.023 91.1967 768.935 91.1967 603.521C91.1967 532.502 115.956 467.245 157.328 415.907Z"
            , Svg.Attributes.fill "#011829"
            ]
            []
        ]
        |> wrap


telegram : String
telegram =
    "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAYAAABw4pVUAAAM8klEQVR4nO2dW3BV1RnH/9/a534OCYEQAklEMJALM3Z0bBVFh6BWCCDKzXurrUXtxc6oD+1DH+qLtmN9aMeZKkw7VVDGWq8kAZ0aOmi8TFERchUttSAJJIEk536y19eHQyTAOdn3cwKc32OyLt/Z//19a+1vrb02UKBAgQIFChQoUKBAgQK5hfJtgG6Yqf6teBV7aAFUtYZJTGdwUAFNBTiULkRhFXyCQBEi2Q9SeijJPR03+7/Or/H6mbSC1LdyCLHotczUwMASgOuJKGimLWaOEKhdEna5WLYqruDuz2+iiM0m28KkEmTeO4PF3qR3PYjuYuZriMjtRD/MnBKC3mPQ1oQr9spXN04bcqIfM0wKQRY2x5aOQt0omFaDyJfb3jkG8BtSKs91r/S35rbvs8mrIHU74jdAqo8DtCifdozBjE+FwBMdy/yvgIjzYUNeBFnYHFuqMj9NhO/ko38tmPEpBD3Stdy/K9d951SQ+qZwuSrE74Xku0E0KcKlBttTwEMHGgOHctWhyFVH9S2RBxjULRj3nCNiAMBKN9P+uqbI/bnq0PELU/MGTxGuyLMgcYfTfTkK41VvMvHjz24tOeFkN44KUt8cuUxKvEyCqp3sJ3fIHiGwoX1ZaK9TPTgmSH1L7Hpmfg3AFKf6yAfMHFHA69pXhHY40b4jY0htU+xOKWULzjMxAICIgirRG7UtUUdCsO2C1DVHHiKSLzj1lD0ZIJCHmLfUN0UetL9tG6ltid5BzFsAytnsLa8wM0jc29nof96uJm0TpL4ldj1L2QQir11tngswcwqCV3UtD+20oz1bBKlvjlwmGbvNZmPPA0aEkNfaMfuyHFrqWznETC9dwGIAwBR1lF6pbuYiqw1ZFkRGYn8GocZqO+c6JKjaTZFNVtuxJEh9S+QBErjLqhHnDSw2WE2zmB5D6pvC5QylC8TFVgw472AehoLazmXBI2aqm/YQBp4uiJEBoiLJ9DvT1c1UqmuKXQfIXedQ1laTUi9hxSwFl5UIzPQR3jys4qWvR023JyUtNbMC6TLcEzNxc+yPdB6IIQi4ulTB+ioFDWUKXON+kUKwJIgQ/BSYrzC68mhYkNqW6EoimpQrfXop8xLWVCpYW+VChT/zfXUkbnkF9/K6HdHlnUCzkUqGBSHCr5CX1WZrCAKunCaw4SIXrp95ujdkomNIWu9U0m/gpCALm2NLJfPVhozKM2Vews0VCm67KLs3ZKJj2Ia7jnBVzfZYg5GxxJAgo1A3ityt+ppmvDfcMFOBYmK06xy2wUMACFJ/AkC3ILpNrW7mIjeivQD5TVmWA2b6CKtmK7j9IhdmG/CGM+mLMxpa4/YYxRxPeBLlejfj6fYQF6K3TUYxFAK+Z9EbzqTDJu8AABD5fCn/WgB/0VNctyAEutO0UQ4w5g13znGh3KdfhWRqFEPhMKYVF0ERmcOvLePHOCT4LtgpSH0rh2Q0ek2+Hz3cAlhcquDmCsWwN0hmHB08gaMDxyGZARBmlGRONNgywzoNXnzpTg7q2eCtz0Ni0WvzuSQ7J0hYW+nCmkoF0zzGb4rhSBSH+/qRSKUAAD6PB1OnhLKWtzVkIb3km1QT1wB4W6usLkGYqSHXm07dAlhapmDDRS5cNV2Y6j41OoojxwYxODzy7d8CPi/mVc6CS1Ey1jmeZPRZfyg8C8GyAbYJAizJlR4XBwlrLHgDkA5P/ceH0DtwHFKeuttDAT/mVpRnHTsAoN32cHXSJkKDnnLagjATmqJ1cHD88AigwaI3jDEcjuDQ0QEkT4anMYpDQcyZPRNC43fYPaB/i+SFYCat3JamIPVvxavYRdkDrgXmBgm3VrqwtlJBiUlvGCORSuHw0X4Mh6Nn/W9a0RRUlc/QlZy2e/wYgwSFFmyPze4BDk9UTlMQVqgGNiavvAJYYpM3ACdnTwPHcXTwxMnZ0+nMKClGRVmp7vbsekLPhFuhGlgVBEKdD7YeruaFCLdUuLCuSsFUtz3hL1t4GqN8egnKS6fpby/FOBR1LnPKLBcAeHeiMtoeAjGDTHrIeG9YNN2+HFgilcLhvn4MR84OT0A6H1RZPgPTi41tAukYZkcT2Qyh6ap6BnXD48c0D+HBahduqXAhZHwJLCta4QkAiAhzZpVN+JyRDSfDFQBIYs29zjoEoSkwsOjlU4CXFnlRFbB3VpYOT/1IprKv4gkhMHf2TEwJBkz14bQgQpIdgnDIyMhb7CZbxUgkT86esoSnMRRFYF7FLAT95l/itT9lcgY6PMT2xY2+OOP5g+bXoseQktHbP4iug//TFMPtUjC/qsKSGFEVOOjggK4XbQ8hChud9j7ZmULTNypuLFewaLpAXZGAMOA0esLTGB63G5dUzYLXbS3V1jUsIZ3Wg2lEq4gOQVizkUzsG5LYdzIEBF3ApcUCi0rTAi0szuyYesPTGD6vB5dUzoLbZX3m4FTKZDxSaF9LfR6SZUajl8go8MGAxAcD6R89w0u4vERgUanAkjIFpW7g6OBx9A2eAOvsK+T3Y27lxHkpIzj1hD4eYYeHEOQxu19FPJZg7OxVsbNXhaAUfjE7jCu9w7rrF4WCuFhHXsoInU7lsMZBkP1aZbRvL1J6bLEmC5KBN/v1v+NTUhTCXJvFiKvAl2HnPURl0a1VRlMQhaRmI1b5T8KNw0ntQbl0ajHmzJpp+w7W7hEJNRcTLI/2tdQUZP/3/YdYctgei7LzYWTiKWvZtKmonKk/SWiEXIwfAEa6bwxo7ojXEbKIiajDFpMm4P1w9g0tB5MeuIOWX07KSi7GDzDa9ezz1TVFkYRdlg3SoDflwleJzGFrIJLAjo8/R/sxZxw1F1NeEqxrs5wuQVwsc3KwV1sWLxGjCRRxAh372/HOl5oTFUOkJHAgBwM6S8U+QRRXcDeDk9ZM0qYtHMj4tByUMQCAByoiX/fgxU/+a1ufPSMSKYf1YHDS7fK26SmrS5DPb6KIIHrfmlnanFAFOuOnT4EjkuBVT90LBCA4dBib3+9CdNT6lczFgM6SdB+6qfsxlyW/aN4k/bRFTg9bx5KZTZyRHMSmth4MJKwNyLkY0BWirXrL6hYkRYGXGawvyWSBjyJ+pMYtGYczr86in33YFp2NdW0JS3e58x7Csbgn9qre0roFOdBIwwx+y5xR+omqhL3RU2ErqZ6d8T3GPmxKVGOI3eiLM37wYQL/7FMN96VyegxxFObXjRxDaywzJ5VnDRtkgtPCVur0ucRR9mFTshrDODVFjqrAw58k8cyBUUMLBV+GJeLGdTQEC+U5I+UNCdK90t9KYMcH9z0RH6IyHbZ86qn3NI5JHzYn52OEz35eYQDPfJHCY58ldV/kdsfHD/7A6MmmhnPXLPCE0TpGSTFhT8SPOBMCMi3IEenHs6n5GOGJE9QtR1Tc93EC/ToG+06HHwgF8+OG6xit0HlToJkZnxqtZ5R/jfgxkEpvpPtG+rE5OR8RDTHG2HtCYn1bAvs1LrijAzphj5ljAI2v7hCxUOiXuleSTNIR92L3kBv71anYnJqPKDLvVs9GX5xxz4cJbP8mc/ySnM7yOgIzM+gxM1VN57Frt0e3nAsHzxCAn89348Fq12k/9qMBifs+TjjUK/+tszF4r5maptc/Xap8VAKOnmFrBwzgT1+k8PAnSewbkuiNM97uVfHYXocyQUxDEPi12eqWVnrqmiL3g8jyGVHnE8T0o44V/r+arm/VgLqm6Asg3G21nfMDua2zMWTp+FjLWzYo4H+IGF1W2znXYcgvZCq40Wo7lgXpaKAwKfL2XCzzTlqYh8FY271ae5uPFrZsampfFtqrCLEazE5NWyYtDE4yKeu7VoT22dGebXt72xv970LQvQDnZMfA5IClYLqnq9Gn+XatXmzdbN25PLCNGD+7MERhSYSfdqwIvGxnq468WlvbEl1Dkrfm/gNfuYHBSSL6YefywDa723bsXef02VryNRA5t38nD7DkMBReZ9fR4mfi2OFX7Y3+d4XC1wHS0a2ouYQYXSC+2ikxAIe/QdW+LLRXpoJXsITuNeVJC2MLAv7v2jWbykbOTjBJn/gsnjrXzvpl4LhgetRKOsQIOTuvr3NFcDNBrZWEF5xO3dvI310pWZcrMYA8fViytiW2hJj/AODyfPSvg3+ToEc6lvl357rjvJ5IVt8SWyyZf0vA0nza8S3Ebcx4smt5YPsF9enVM6nZHmsQQt0I0Orcn+vIMTC/zkJ5Lh+fWj2TSSHIGNXNXORBfF36jEJeTCCPE/0wOMmSditEW5Pk+8eBRtL/Pp3DTCpBxnPpTg4mZWQxsUh/4F7yQhKmj4kaAaOdgF2SRGtQ9b63ZxU5vgvTDJNWkExUN0crPUQ1zHIBWEwHcYhAJVJy+nNLRGEiPgGmMEgOCIjulMrdPasCEx6JVKBAgQIFChQoUKBAgQIXMv8HSm0W5FdV0MkAAAAASUVORK5CYII="


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
