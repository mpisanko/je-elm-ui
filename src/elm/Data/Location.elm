module Data.Location exposing (..)

import Json.Decode exposing (..)


type alias Location =
    { id : String
    , value : String
    }


locationDecoder : Decoder Location
locationDecoder =
    map2 Location (field "id" string) (field "value" string)


suggestedLocationDecoder : Decoder Location
suggestedLocationDecoder =
    map2 filterNullLocations (field "geonameid" (nullable string)) (field "display_name" (nullable string))


emptyLocationFilter : List Location -> List Location
emptyLocationFilter locations =
    List.filter
        (\{ id, value } ->
            let
                pair =
                    ( id, value )
            in
                case pair of
                    ( "", "" ) ->
                        False

                    _ ->
                        True
        )
        locations


filterNullLocations : Maybe String -> Maybe String -> Location
filterNullLocations id value =
    case ( id, value ) of
        ( Just i, Just v ) ->
            Location i v

        _ ->
            Location "" ""


locationSuggestDecoder : Decoder (List Location)
locationSuggestDecoder =
    list suggestedLocationDecoder
