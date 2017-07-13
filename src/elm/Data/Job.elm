module Data.Job exposing (..)

import Data.Location as Location
import Json.Decode exposing (..)


type alias Job =
    { id : String
    , rank : Int
    , title : String
    , abstract : String
    , createdAt : String
    , location : Location.Location
    , diagnostics : Maybe (List Diagnostic)
    , duplicates : Maybe (List DuplicateJob)
    }


type alias DuplicateJob =
    { id : String
    , title : String
    }


type alias Diagnostic =
    { diagType : String
    , source : String
    , info : String
    }


diagnosticsDecoder : Decoder (List Diagnostic)
diagnosticsDecoder =
    Json.Decode.list diagnosticDecoder


diagnosticDecoder : Decoder Diagnostic
diagnosticDecoder =
    map3 Diagnostic (field "type" string) (field "source" string) (field "info" string)


duplicatesDecoder : Decoder (List DuplicateJob)
duplicatesDecoder =
    Json.Decode.list duplicateJobDecoder


duplicateJobDecoder : Decoder DuplicateJob
duplicateJobDecoder =
    map2 DuplicateJob (field "id" string) (field "title" string)


jobsDecoder : Decoder (List Job)
jobsDecoder =
    Json.Decode.list jobDecoder


jobDecoder : Decoder Job
jobDecoder =
    Json.Decode.map8 Job
        (field "id" string)
        (field "rank" int)
        (field "title"
            string
        )
        (field "abstract" string)
        (field "createdAt" string)
        (field
            "location"
            Location.locationDecoder
        )
        (maybe
            (field "diag"
                diagnosticsDecoder
            )
        )
        (maybe (field "duplicates" duplicatesDecoder))
