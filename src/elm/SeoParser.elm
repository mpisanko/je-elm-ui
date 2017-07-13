module SeoParser exposing (..)

import String exposing (dropLeft, split)
import Navigation


{-
   Parse the SEO URLs like:
   /It-jobs -> Category categoty
   /jobs-in-Caberra-ACT -> Location location
   /It-jobs-in-Canberra-ACT -> CategoryLocation category location
-}


type SeoUrl
    = Category String
    | Location String
    | CategoryInLocation String String
    | NotSeo


parsePath : Navigation.Location -> SeoUrl
parsePath location =
    let
        url =
            dropLeft 1 location.pathname
    in
        case split "-jobs-in-" url of
            [ cat, loc ] ->
                CategoryInLocation cat loc

            _ ->
                case split "jobs-in-" url of
                    [ "", loc ] ->
                        Location loc

                    _ ->
                        case split "-jobs" url of
                            [ cat, "" ] ->
                                Category cat

                            _ ->
                                NotSeo
