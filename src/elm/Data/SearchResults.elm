module Data.SearchResults exposing (..)

import Data.Job as Job
import Data.PageDetails as PageDetails
import Json.Decode exposing (..)


type alias SearchResults =
    { page : PageDetails.PageDetails
    , jobs : List Job.Job
    }


searchResultsDecoder : Decoder SearchResults
searchResultsDecoder =
    map2 SearchResults (field "page" PageDetails.pageDecoder) (field "jobs" Job.jobsDecoder)
