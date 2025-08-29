module Frontend exposing (Model, app)

import Html exposing (Html, label, text)
import Html.Attributes exposing (checked, placeholder, style, type_, value)
import Html.Events exposing (onCheck, onClick, onInput)
import Lamdera exposing (sendToBackend)
import Types exposing (..)


type alias Model =
    FrontendModel


app =
    Lamdera.frontend
        { init = \_ _ -> init
        , update = update
        , updateFromBackend = updateFromBackend
        , view =
            \model ->
                { title = "v1"
                , body = [ view model ]
                }
        , subscriptions = \_ -> Sub.none
        , onUrlChange = \_ -> FNoop
        , onUrlRequest = \_ -> FNoop
        }


init : ( Model, Cmd FrontendMsg )
init =
    ( { counter = 50
      , incrementAmount = 1
      , isCenterLineVisible = False
      , clientId = ""
      }
    , Cmd.none
    )


update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
update msg model =
    case msg of
        Increment ->
            let
                newValue =
                    min (model.counter + model.incrementAmount) 100
            in
            ( { model | counter = newValue }, sendToBackend (CounterChanged newValue) )

        Decrement ->
            let
                newValue =
                    max (model.counter - model.incrementAmount) 0
            in
            ( { model | counter = newValue }, sendToBackend (CounterChanged newValue) )

        IncrementAmountChange stringValue ->
            case String.toInt stringValue of
                Just intValue ->
                    ( { model | incrementAmount = intValue }, sendToBackend (IncrementAmountChanged intValue) )

                _ ->
                    ( model, Cmd.none )

        IsCenterLineVisibleChange newValue ->
            ( { model | isCenterLineVisible = newValue }, sendToBackend (IsCenterLineVisibleChanged newValue) )

        FNoop ->
            ( model, Cmd.none )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        CounterNewValue newValue clientId ->
            ( { model | counter = newValue, clientId = clientId }, Cmd.none )

        IncrementAmountNewValue newValue clientId ->
            ( { model | incrementAmount = newValue, clientId = clientId }, Cmd.none )

        IsCenterLineVisibleNewValue newValue clientId ->
            ( { model | isCenterLineVisible = newValue, clientId = clientId }, Cmd.none )


view : Model -> Html FrontendMsg
view model =
    Html.div
        []
        [ Html.node "style"
            []
            [ Html.text overscrollDisabledStyle
            ]
        , Html.div
            [ style "display" "flex"
            , style "height" "200vh"
            ]
            [ Html.div
                [ style "background" "red"
                , style "width" (String.fromInt model.counter ++ "%")
                ]
                []
            , Html.div
                [ style "background" "blue"
                , style "width" (String.fromInt (100 - model.counter) ++ "%")
                ]
                []
            , if model.isCenterLineVisible then
                Html.div
                    [ style "position" "absolute"
                    , style "width" "50%"
                    , style "height" "200vh"
                    , style "border-right" ("solid " ++ String.fromInt model.incrementAmount ++ "vw")
                    , style "right" ("calc(50% - 0.5*" ++ String.fromInt model.incrementAmount ++ "vw)")
                    ]
                    [ text "" ]

              else
                Html.div [] []
            ]
        , Html.div
            [ style "padding" "30px"
            , style "position" "absolute"
            , style "display" "grid"
            ]
            [ Html.div
                [ style "font-size" "34px"
                , style "display" "flex"
                , style "align-items" "center"
                , style "gap" "10px"
                ]
                [ Html.button (onClick Decrement :: buttonStyle) [ text "<" ]
                , Html.text (String.fromInt model.counter ++ "%")
                , Html.button (onClick Increment :: buttonStyle) [ text ">" ]
                , Html.input
                    ([ type_ "number"
                     , placeholder ""
                     , value (String.fromInt model.incrementAmount)
                     , onInput IncrementAmountChange
                     ]
                        ++ inputStyle
                    )
                    []
                ]
            , label
                [ style "font-size" "initial"
                ]
                [ Html.input
                    [ type_ "checkbox"
                    , checked model.isCenterLineVisible
                    , onCheck IsCenterLineVisibleChange
                    ]
                    []
                , text "Középvonal megjelenítése"
                ]
            ]
        ]


buttonStyle : List (Html.Attribute msg)
buttonStyle =
    [ style "width" "50px"
    , style "height" "50px"
    ]


inputStyle : List (Html.Attribute msg)
inputStyle =
    [ style "width" "80px"
    , style "margin" "20px"
    , style "font-size" "inherit"
    ]


overscrollDisabledStyle : String
overscrollDisabledStyle =
    """
body {
  overscroll-behavior: none;
  box-sizing: border-box;
}
"""
