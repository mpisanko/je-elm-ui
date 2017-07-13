module Util exposing (..)


typeToString : msg -> String
typeToString msg =
    msg |> toString |> String.toLower
