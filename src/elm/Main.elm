module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Navigation
import UrlParser exposing ((<?>), (</>), s, stringParam, Parser, map, parsePath)
import SeoParser
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Card as Card
import Request.Location as LocationRequest
import Data.Location exposing (..)
import Http
import Data.Location as Location
import Data.SearchResults as SearchResults
import Data.SearchRequest as SearchRequest
import Data.Job as Job
import Request.Search as Search
import Views.JobRow as JobRow
import Views.Header as Header


-- APP


main : Program Never Model Msg
main =
    Navigation.program UrlChange { init = init, view = view, update = update, subscriptions = (\_ -> Sub.none) }



-- MODEL


type Route
    = Search (Maybe String) (Maybe String)
    | NotSearch


route : Parser (Route -> a) a
route =
    UrlParser.map Search (UrlParser.s "j" <?> stringParam "q" <?> stringParam "l")


type Results
    = LoadingSearchResults
    | HasSearchResults SearchResults.SearchResults
    | SearchNotPerformed


type alias Model =
    { searchRequest : SearchRequest.SearchRequest
    , results : Results
    }


parseSearchUrl : Navigation.Location -> Route
parseSearchUrl location =
    case parsePath route location of
        Nothing ->
            case SeoParser.parsePath location of
                SeoParser.Category cat ->
                    Search (Just cat) Nothing

                SeoParser.Location loc ->
                    Search Nothing (Just loc)

                SeoParser.CategoryInLocation cat loc ->
                    Search (Just cat) (Just loc)

                SeoParser.NotSeo ->
                    NotSearch

        Just route ->
            route


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        parsedRoute =
            parseSearchUrl location

        d =
            Debug.log "parsedRoute" parsedRoute

        kw =
            case parsedRoute of
                Search Nothing _ ->
                    ""

                Search (Just value) _ ->
                    value

                NotSearch ->
                    ""

        loc =
            case parsedRoute of
                Search _ Nothing ->
                    ""

                Search _ (Just value) ->
                    value

                NotSearch ->
                    ""

        cmd =
            case parsedRoute of
                NotSearch ->
                    Cmd.none

                _ ->
                    Http.send InitialLocationResolution (LocationRequest.suggest loc "AU")

        searchRequest =
            SearchRequest.init
    in
        ( { searchRequest = { searchRequest | query = kw, location = loc, chosenLocation = Nothing }, results = SearchNotPerformed }, cmd )



-- UPDATE


type Msg
    = UrlChange Navigation.Location
    | InitialLocationResolution (Result Http.Error (List Location))
    | DoSearch
    | SearchResultsReceived (Result Http.Error SearchResults.SearchResults)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        sr =
            model.searchRequest
    in
        case msg of
            UrlChange location ->
                ( model, Cmd.none )

            InitialLocationResolution (Ok locations) ->
                let
                    filteredLocations =
                        (Location.emptyLocationFilter locations)

                    location =
                        List.head filteredLocations
                in
                    ( { model | searchRequest = { sr | chosenLocation = location }, results = LoadingSearchResults }, Http.send SearchResultsReceived (Search.performSearch sr) )

            InitialLocationResolution (Err err) ->
                let
                    x =
                        Debug.log "error" err
                in
                    ( model, Cmd.none )

            DoSearch ->
                ( model, Http.send SearchResultsReceived (Search.performSearch sr) )

            SearchResultsReceived (Ok searchResults) ->
                ( { model | results = HasSearchResults searchResults }, Cmd.none )

            SearchResultsReceived (Err err) ->
                let
                    x =
                        Debug.log "error" err
                in
                    ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        locationText =
            case model.searchRequest.chosenLocation of
                Nothing ->
                    model.searchRequest.location

                Just loc ->
                    loc.value
    in
        div []
            [ Header.render
            , Html.form []
                [ Grid.container []
                    [ Grid.row []
                        [ Grid.col [ Col.md2 ] [ h1 [] [ text "TechJobs Australia" ] ]
                        , Grid.col [ Col.md3 ] [ label [] [ text "What" ], input [ type_ "text", value model.searchRequest.query ] [] ]
                        , Grid.col [ Col.md3 ] [ label [] [ text "Where" ], input [ type_ "text", value locationText ] [] ]
                        , Grid.col [ Col.md1 ] [ input [ type_ "submit" ] [ text "Submit" ] ]
                        ]
                    ]
                ]
            , Grid.container []
                [ Grid.row []
                    [ Grid.col [ Col.md2 ] []
                    , Grid.col [ Col.md8 ] [ renderJobs model.results ]
                    , Grid.col [ Col.md2 ] []
                    ]
                ]
            ]


renderJobs : Results -> Html Msg
renderJobs result =
    case result of
        LoadingSearchResults ->
            text "loading"

        HasSearchResults res ->
            div [] (List.map JobRow.renderJob res.jobs)

        SearchNotPerformed ->
            text "nojobs"
