module Views.JobRow exposing (renderJob)

import Html exposing (Html, text, span, pre, ul, li, p)
import Html.Attributes exposing (class)
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Row as Row
import Bootstrap.Card as Card
import Data.Job as Job exposing (Job, Diagnostic, DuplicateJob)
import Data.Location as Location exposing (Location)


renderJob : Job -> Html msg
renderJob job =
    Grid.row [ Row.attrs [ class "job-row" ] ]
        [ Grid.col []
            [ Card.config []
                |> Card.headerH6 [] [ jobHeader job.rank job.title ]
                |> Card.block []
                    [ Card.text []
                        [ Grid.container []
                            [ Grid.row []
                                [ Grid.col []
                                    [ span [ class "bold" ] [ text "Job Id: " ]
                                    , span [ class "italic" ] [ text job.id ]
                                    ]
                                , Grid.col []
                                    [ span [ class "bold" ] [ text "Created at: " ]
                                    , span [ class "italic" ] [ text job.createdAt ]
                                    ]
                                ]
                            , Grid.row []
                                [ Grid.col []
                                    [ span [ class "bold" ] [ text "Location: " ]
                                    , span [ class "italic" ] [ text job.location.value ]
                                    ]
                                ]
                            ]
                        ]
                    , Card.text [] [ text job.abstract ]
                    , duplicateJobs job.duplicates
                    ]
                |> addFooter job
                |> Card.view
            ]
        ]


duplicateJobs : Maybe (List DuplicateJob) -> Card.BlockItem msg
duplicateJobs jobs =
    case jobs of
        Nothing ->
            Card.text [] [ text "" ]

        Just duplicates ->
            Card.text []
                [ p [ class "bold" ] [ text "Duplicates" ]
                , ul [] (List.map renderDuplicate duplicates)
                ]


renderDuplicate : DuplicateJob -> Html msg
renderDuplicate duplicate =
    li [] [ text (duplicate.title ++ " [" ++ duplicate.id ++ "]") ]


jobHeader : Int -> String -> Html msg
jobHeader rank title =
    text ("(" ++ (toString rank) ++ ") " ++ title)


addFooter : Job -> Card.Config msg -> Card.Config msg
addFooter job card =
    case job.diagnostics of
        Nothing ->
            card

        Just diagList ->
            card
                |> Card.footer [] [ pre [] [ text (getDiagText (List.head diagList)) ] ]


getDiagText : Maybe Diagnostic -> String
getDiagText diag =
    case diag of
        Nothing ->
            ""

        Just diag ->
            diag.info
