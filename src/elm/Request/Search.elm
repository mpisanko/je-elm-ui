module Request.Search exposing (..)

import Data.SearchResults as SR
import Http
import Data.SearchRequest as SearchRequest
import Util exposing (typeToString)


performSearch : SearchRequest.SearchRequest -> Http.Request SR.SearchResults
performSearch sr =
    let
        d =
            typeToString sr.diagMode

        ps =
            toString sr.pageSize

        origin =
            typeToString sr.origin

        country =
            typeToString sr.country

        deDupMode =
            typeToString sr.deDupMode

        li =
            case sr.chosenLocation of
                Nothing ->
                    ""

                Just location ->
                    location.id

        url =
            "http://search.sandbox.jobapi.io/s?diagMode="
                ++ d
                ++ "&o="
                ++ origin
                ++ "&cc="
                ++ country
                ++ "&dm="
                ++ deDupMode
                ++ "&ps="
                ++ ps
                ++ "&fi=6&li="
                ++ li
                ++ "&k="
                ++ (Http.encodeUri sr.query)
    in
        Http.get url SR.searchResultsDecoder
