module Data.SearchResults exposing (..)

import Data.SearchStatistics as SearchStatistics
import Data.Job as Job
import Data.PageDetails as PageDetails
import Json.Decode exposing (..)


type alias SearchResults =
    { page : PageDetails.PageDetails
    , jobs : List Job.Job
    , stats : SearchStatistics.SearchStatistics
    }


searchResultsDecoder : Decoder SearchResults
searchResultsDecoder =
    map3 SearchResults (field "page" PageDetails.pageDecoder) (field "jobs" Job.jobsDecoder) (field "stats" SearchStatistics.statsDecoder)
