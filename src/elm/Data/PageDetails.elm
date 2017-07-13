module Data.PageDetails exposing (..)

import Json.Decode exposing (..)


type alias PageDetails =
    { pageSize : Int
    , pageNumber : Int
    , resultCount : Int
    , totalJobs : Int
    }


pageDecoder : Decoder PageDetails
pageDecoder =
    map4 PageDetails (field "pageSize" int) (field "pageNumber" int) (field "resultCount" int) (field "totalJobs" int)
