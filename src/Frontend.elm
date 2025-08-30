module Frontend exposing (Model, app)

import Browser.Navigation
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
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


fankadeliSideData : SideData
fankadeliSideData =
    { name = "FankaDeli"
    , imageSrc = "/fankadeli.jpg"
    , color = rgb255 0xFF 0x00 0x00
    }


famSideData : SideData
famSideData =
    { name = "FAM"
    , imageSrc = "/fam.jpg"
    , color = rgb255 0x00 0x00 0xFF
    }


init : Url -> Browser.Navigation.Key -> ( FrontendModel, Cmd FrontendMsg )
init url key =
    ( { key = key
      , currentRoute = Route.fromUrl url
      , splitRatio = 50
      , incrementAmount = 1
      , isCenterLineVisible = False
      , avatarScale = 15
      , fankadeliSide = Left
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
                    min (model.splitRatio + model.incrementAmount) 100
            in
            ( { model | splitRatio = newValue }, sendToBackend (SplitRatioChanged newValue) )

        Decrement ->
            let
                newValue =
                    max (model.splitRatio - model.incrementAmount) 0
            in
            ( { model | splitRatio = newValue }, sendToBackend (SplitRatioChanged newValue) )

        IncrementAmountChange stringValue ->
            case String.toInt stringValue of
                Just intValue ->
                    ( { model | incrementAmount = intValue }, sendToBackend (IncrementAmountChanged intValue) )

                _ ->
                    ( model, Cmd.none )

        IsCenterLineVisibleChange newValue ->
            ( { model | isCenterLineVisible = newValue }, sendToBackend (IsCenterLineVisibleChanged newValue) )

        AvatarScaleChange newValue ->
            ( { model | avatarScale = newValue }, sendToBackend (AvatarScaleChanged newValue) )

        FankaDeliSideChange newValue ->
            let
                newSplitRatio =
                    100 - model.splitRatio
            in
            ( { model
                | fankadeliSide = newValue
                , splitRatio = newSplitRatio
              }
            , sendToBackend (FankaDeliSideChanged newValue newSplitRatio)
            )

        ResetSplitRatioButtonTap ->
            let
                newSplitRatio =
                    50
            in
            ( { model | splitRatio = newSplitRatio }, sendToBackend (SplitRatioChanged newSplitRatio) )

        FNoop ->
            ( model, Cmd.none )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        SplitRatioNewValue newValue clientId ->
            ( { model | splitRatio = newValue, clientId = clientId }, Cmd.none )

        IncrementAmountNewValue newValue clientId ->
            ( { model | incrementAmount = newValue, clientId = clientId }, Cmd.none )

        IsCenterLineVisibleNewValue newValue clientId ->
            ( { model | isCenterLineVisible = newValue, clientId = clientId }, Cmd.none )

        AvatarScaleNewValue newValue clientId ->
            ( { model | avatarScale = newValue, clientId = clientId }, Cmd.none )

        FankadeliSideNewValue newSideValue newSplitRatioValue clientId ->
            ( { model
                | fankadeliSide = newSideValue
                , splitRatio = newSplitRatioValue
                , clientId = clientId
              }
            , Cmd.none
            )


view : FrontendModel -> Element FrontendMsg
view model =
    case model.currentRoute of
        Just Route.AdminPanel ->
            adminView model

        Nothing ->
            homeView model


homeView : Model -> Element FrontendMsg
homeView model =
    let
        getSideData side =
            if side == model.fankadeliSide then
                fankadeliSideData

            else
                famSideData

        leftSideData =
            getSideData Left

        rightSideData =
            getSideData Right
    in
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
            , inFront
                (row
                    [ width fill
                    , spaceEvenly
                    ]
                    [ avatarView
                        { sideData =
                            leftSideData
                        , side = Left
                        , scale = model.avatarScale
                        }
                    , avatarView
                        { sideData =
                            rightSideData
                        , side = Right
                        , scale = model.avatarScale
                        }
                    ]
                )
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
                [ Background.color leftSideData.color
                , width (fillPortion model.splitRatio)
                , height fill
                ]
                Element.none
            , el
                [ Background.color rightSideData.color
                , width (fillPortion (100 - model.splitRatio))
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
                    , label =
                        el
                            [ centerX
                            , centerY
                            ]
                        <|
                            text "<"
                    }
                , text (String.fromInt model.splitRatio ++ "%")
                , Input.button
                    buttonStyle
                    { onPress = Just Increment
                    , label =
                        el
                            [ centerX
                            , centerY
                            ]
                        <|
                            text ">"
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
        , Input.slider
            [ height (px 30)
            , behindContent
                (el
                    [ width fill
                    , height (px 2)
                    , centerY
                    , Background.color (rgb255 0x90 0x90 0x90)
                    , Border.rounded 2
                    ]
                    Element.none
                )
            ]
            { onChange = round >> AvatarScaleChange
            , label =
                Input.labelAbove []
                    (text ("Avatár méret: " ++ String.fromInt model.avatarScale))
            , min = 5
            , max = 50
            , step = Just 1
            , value = toFloat model.avatarScale
            , thumb =
                Input.defaultThumb
            }
        , Input.radio
            [ padding 10
            , spacing 20
            ]
            { onChange = FankaDeliSideChange
            , selected = Just model.fankadeliSide
            , label = Input.labelAbove [] (text "FankaDeli oldal")
            , options =
                [ Input.option Left (text "Bal")
                , Input.option Right (text "Jobb")
                ]
            }
        , column []
            [ el [ height (px 200) ] <| Element.none
            , Input.button
                [ Background.color (rgb255 0x90 0x90 0x90)
                , padding 10
                ]
                { onPress = Just ResetSplitRatioButtonTap
                , label =
                    el
                        [ centerX
                        , centerY
                        ]
                    <|
                        text "Alaphelyzet"
                }
            ]
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


avatarView : { sideData : SideData, side : Side, scale : Int } -> Element msg
avatarView { sideData, side, scale } =
    let
        alignment =
            case side of
                Left ->
                    alignLeft

                Right ->
                    alignRight
    in
    column
        [ height fill
        , spacing (round (4 * toFloat scale ^ 0.4))
        , padding (round (5 * toFloat scale ^ 0.4))
        ]
        [ image
            [ width (px (scale * 10))
            , Border.rounded 10000
            , clip
            , alignment
            ]
            { src = sideData.imageSrc
            , description = ""
            }
        , el
            [ Font.size (round (10 * toFloat scale ^ 0.5))
            , Font.bold
            , Font.color (rgb255 0xFF 0xFF 0xFF)
            , alignment
            ]
          <|
            text sideData.name
        ]
