module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Navigation
import UrlParser exposing ((<?>), (</>), s, stringParam, Parser, map, parsePath)
import Bootstrap.Grid as Grid


-- APP


main : Program Never Model Msg
main =
    Navigation.program UrlChange { init = init, view = view, update = update, subscriptions = (\_ -> Sub.none) }



-- MODEL


type Route
    = Search (Maybe String) (Maybe String)
    | Category String
    | Location String
    | CategoryInLocation String String
    | NotSearch


route : Parser (Route -> a) a
route =
    UrlParser.oneOf
        [ UrlParser.map Search (UrlParser.s "j" <?> stringParam "q" <?> stringParam "l")
        , UrlParser.map Category (UrlParser.string </> UrlParser.s "-jobs")
        , UrlParser.map Location (UrlParser.s "jobs-in-" </> UrlParser.string)
        , UrlParser.map CategoryInLocation (UrlParser.string </> UrlParser.s "-jobs-in-" </> UrlParser.string)
        ]


type alias Model =
    { keywords : String
    , location : String
    }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        parsedRoute =
            case parsePath route location of
                Nothing ->
                    NotSearch

                Just route ->
                    route

        kw =
            case parsedRoute of
                Search Nothing _ ->
                    "NANA"

                Search (Just value) _ ->
                    value

                Category category ->
                    category

                Location location ->
                    "N/A"

                CategoryInLocation category _ ->
                    category

                NotSearch ->
                    "NotSearchs"

        loc =
            case parsedRoute of
                Search _ Nothing ->
                    "NANA"

                Search _ (Just value) ->
                    value

                Location location ->
                    location

                Category _ ->
                    "N/A"

                CategoryInLocation _ location ->
                    location

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
