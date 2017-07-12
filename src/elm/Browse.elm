module Browse exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import UrlParser exposing (..)
import Navigation exposing (Location)


{-
   this is app for handling /findjobs section
   we need to handle routes:
    /findjobs/Category
    /findjobs/Category/SubCategory
    /findjobs/in/Location
-}


main : Program Never BrowseModel Msg
main =
    Navigation.program UrlChange { init = init, view = view, update = update, subscriptions = (\_ -> Sub.none) }


type alias BrowseModel =
    { category : Maybe String
    , subcategory : Maybe String
    , location : Maybe String
    }


type Route
    = BrowseRoute
    | Category String
    | CategoryLocation String String
    | Location String
    | NotBrowse


route : Parser (Route -> a) a
route =
    UrlParser.oneOf
        [ UrlParser.map BrowseRoute (UrlParser.s "findjobs")
        , UrlParser.map Category (UrlParser.s "findjobs" </> UrlParser.string)
        , UrlParser.map CategoryLocation (UrlParser.s "findjobs" </> UrlParser.string </> UrlParser.string)
        , UrlParser.map Location (UrlParser.s "findjobs/in" </> UrlParser.string)
        ]


init : Navigation.Location -> ( BrowseModel, Cmd Msg )
init location =
    let
        parsedRoute =
            case parsePath route location of
                Nothing ->
                    NotBrowse

                Just route ->
                    route

        category =
            case parsedRoute of
                BrowseRoute ->
                    Nothing

                NotBrowse ->
                    Nothing

                Category category ->
                    Just category

                CategoryLocation category _ ->
                    Just category

                Location _ ->
                    Nothing

        subcategory =
            case parsedRoute of
                BrowseRoute ->
                    Nothing

                NotBrowse ->
                    Nothing

                Category _ ->
                    Nothing

                CategoryLocation _ subcategory ->
                    Just subcategory

                Location _ ->
                    Nothing

        loc =
            case parsedRoute of
                BrowseRoute ->
                    Nothing

                NotBrowse ->
                    Nothing

                Category _ ->
                    Nothing

                CategoryLocation _ _ ->
                    Nothing

                Location location ->
                    Just location
    in
        ( { category = category, subcategory = subcategory, location = loc }, Cmd.none )


type Msg
    = UrlChange Navigation.Location


update : Msg -> BrowseModel -> ( BrowseModel, Cmd Msg )
update msg browse =
    case msg of
        UrlChange location ->
            ( browse, Cmd.none )


view : BrowseModel -> Html Msg
view browse =
    let
        cat =
            case browse.category of
                Nothing ->
                    ""

                Just c ->
                    c

        subcat =
            case browse.subcategory of
                Nothing ->
                    ""

                Just s ->
                    s

        loc =
            case browse.location of
                Nothing ->
                    ""

                Just l ->
                    l
    in
        div []
            [ div [] [ text ("category: " ++ cat) ]
            , div [] [ text ("subcategory: " ++ subcat) ]
            , div [] [ text ("location: " ++ loc) ]
            ]
