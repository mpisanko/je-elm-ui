module Data.SearchRequest exposing (..)

import Data.IpAddress exposing (IpAddress)
import Data.Location exposing (Location)


type alias SearchRequest =
    { query : String
    , location : String
    , chosenLocation : Maybe Location
    , diagMode : Bool
    , origin : Origin
    , country : Country
    , deDupMode : DeDuplicationMode
    , ipAddress : IpAddress
    , pageSize : Int
    }


type Country
    = AU
    | NZ


type Origin
    = Jora
    | Seek


type DeDuplicationMode
    = Off
    | Filter
    | Rollup


init : SearchRequest
init =
    SearchRequest "" "" Nothing False Jora AU Off "" 20
