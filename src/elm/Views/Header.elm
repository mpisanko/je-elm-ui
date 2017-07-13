module Views.Header exposing (render)

import Html exposing (Html, div, text, table, tr, td, span, tbody, form, img, a, button, i, input, ul, li, strong)
import Html.Attributes exposing (..)


render : Html msg
render =
    div [ id "new_top_nav" ]
        [ div [ class "row" ]
            [ div [ class "col-3" ]
                [ div [ id "logoc" ]
                    [ a [ href "/", id "logo", title "Jora" ] [ img [ title "Jora", src "//cdn1.jora.com/assets/au/logo-5849cff099caf96347f20f88ba7476ed.png", alt "Logo" ] [] ]
                    ]
                ]
            , div [ class "col-8 col-offset-1" ]
                [ Html.form [ action "/j", class "header_search_form new", attribute "data-ga-label" "desktop_serp_header", attribute "data-widget" "SearchFormWidget", method "get" ]
                    [ table []
                        [ tbody []
                            [ tr []
                                [ td [] [ span [ class "what-where" ] [ text "what:" ] ], td [] [ span [ class "what-where" ] [ text "where:" ] ] ]
                            , tr []
                                [ td [] [ input [ type_ "text", name "q", id "q", value "", maxlength 512, placeholder "job title, keywords or company", autocomplete False, class "acInput" ] [] ]
                                , td [] [ input [ type_ "text", name "l", id "l", value "", maxlength 64, placeholder "city, state or postcode", autocomplete False, class "acInput" ] [] ]
                                , td [] [ button [ name "button", type_ "submit", class "button", id "fj" ] [ span [] [ i [ class "jora-icon-search" ] [] ] ], input [ type_ "hidden", name "sp", id "sp", value "search" ] [] ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        , div [ class "new", id "account" ]
            [ div [ class "account-nav" ]
                [ ul []
                    [ li []
                        [ a [ href "https://employer.jora.com?cc=AU", class "text-link post-job" ]
                            [ text "Post Job", strong [] [ text "Free" ] ]
                        ]
                    , li []
                        [ a [ href "/login", rel "nofollow", class "login button secondary" ] [ text "Log In" ] ]
                    ]
                ]
            ]
        ]
