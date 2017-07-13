module Request.Location exposing (..)

import Data.Location as Location
import Http


suggest : String -> String -> Http.Request (List Location.Location)
suggest query country =
    let
        cc =
            -- because we downcase all the type to string conversions by default + this expects upper
            String.toUpper country

        url =
            "http://geocoder.sandbox.jobapi.io/geocoder/suggest?country=" ++ cc ++ "&query=" ++ (Http.encodeUri query)
    in
        Http.get url Location.locationSuggestDecoder
