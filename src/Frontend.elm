module Frontend exposing (Model, app)

import Browser.Navigation
import Element exposing (..)
import Element.Background as Background
import Element.Input as Input
import Html
import Html.Attributes
import Lamdera exposing (sendToBackend)
import Route
import Types exposing (..)
import Url exposing (Url)


type alias Model =
    FrontendModel


app =
    Lamdera.frontend
        { init = init
        , update = update
        , updateFromBackend = updateFromBackend
        , view =
            \model ->
                { title = "v1"
                , body =
                    [ Element.layout []
                        (view model)
                    ]
                }
        , subscriptions = \_ -> Sub.none
        , onUrlChange = UrlChanged
        , onUrlRequest = \_ -> FNoop
        }


init : Url -> Browser.Navigation.Key -> ( FrontendModel, Cmd FrontendMsg )
init url key =
    ( { key = key
      , currentRoute = Route.fromUrl url
      , counter = 50
      , incrementAmount = 1
      , isCenterLineVisible = False
      , clientId = ""
      }
    , Cmd.none
    )


update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
update msg model =
    case msg of
        UrlChanged url ->
            ( { model | currentRoute = Route.fromUrl url }, Cmd.none )

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


view : FrontendModel -> Element FrontendMsg
view model =
    case model.currentRoute of
        Just Route.AdminPanel ->
            adminView model

        Nothing ->
            homeView model


homeView : Model -> Element FrontendMsg
homeView model =
    column
        [ spacing 20
        , width fill
        , height fill
        ]
        [ Element.html
            (Html.node "style"
                []
                [ Html.text overscrollDisabledStyle
                ]
            )
        , row
            [ width fill
            , height fill
            , if model.isCenterLineVisible then
                inFront
                    (row [ width fill, height fill ]
                        [ el
                            [ width (fillPortion (50 - (model.incrementAmount // 2)))
                            ]
                            Element.none
                        , el
                            [ width (fillPortion model.incrementAmount)
                            , Background.color (rgb255 0x00 0x00 0x00)
                            , height fill
                            ]
                            Element.none
                        , el
                            [ width (fillPortion (50 - (model.incrementAmount // 2)))
                            ]
                            Element.none
                        ]
                    )

              else
                htmlAttribute (Html.Attributes.class "")
            ]
            [ el
                [ Background.color (rgb255 0xFF 0x00 0x00)
                , width (fillPortion model.counter)
                , height fill
                ]
                Element.none
            , el
                [ Background.color (rgb255 0x00 0x00 0xFF)
                , width (fillPortion (100 - model.counter))
                , height fill
                ]
                Element.none
            ]
        ]


adminView : Model -> Element FrontendMsg
adminView model =
    column [ width fill, spacing 20, paddingXY 20 20 ]
        [ row [ spacing 20 ]
            [ row [ spacing 10 ]
                [ Input.button
                    buttonStyle
                    { onPress = Just Decrement
                    , label = text "<"
                    }
                , text (String.fromInt model.counter ++ "%")
                , Input.button
                    buttonStyle
                    { onPress = Just Increment
                    , label = text ">"
                    }
                ]
            , Input.text [ width (px 80) ]
                { text = String.fromInt model.incrementAmount
                , onChange = IncrementAmountChange
                , placeholder = Nothing
                , label = Input.labelLeft [] (text "Nagyság:")
                }
            ]
        , el []
            (Input.checkbox []
                { onChange = IsCenterLineVisibleChange
                , icon = Input.defaultCheckbox
                , checked = model.isCenterLineVisible
                , label =
                    Input.labelRight []
                        (text "Középvonal megjelenítése")
                }
            )
        ]


buttonStyle =
    [ Background.color (rgb255 0x90 0x90 0x90)
    , height (px 50)
    , width (px 50)
    ]


overscrollDisabledStyle : String
overscrollDisabledStyle =
    """
body {
  overscroll-behavior: none;
  box-sizing: border-box;
}
"""
