module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Navigation
import UrlParser exposing ((<?>), (</>), s, stringParam, Parser, map, parsePath)
import SeoParser
import Bootstrap.Grid as Grid


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


type alias Model =
    { keywords : String
    , location : String
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

        kw =
            case parsedRoute of
                Search Nothing _ ->
                    "NANA"

                Search (Just value) _ ->
                    value

                NotSearch ->
                    "NotSearch"

        loc =
            case parsedRoute of
                Search _ Nothing ->
                    "NANA"

                Search _ (Just value) ->
                    value

                NotSearch ->
                    "NotSearch"
    in
        ( { keywords = kw, location = loc }, Cmd.none )



-- UPDATE


type Msg
    = UrlChange Navigation.Location


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    Html.form []
        [ Grid.container []
            [ Grid.row []
                [ Grid.col [] [ h1 [] [ text "TechJobs Australia" ] ]
                , Grid.col [] [ label [] [ text "What" ], input [ type_ "text", value model.keywords ] [] ]
                , Grid.col [] [ label [] [ text "Where" ], input [ type_ "text", value model.location ] [] ]
                , Grid.col [] [ input [ type_ "submit" ] [ text "Submit" ] ]
                ]
            ]
        ]
