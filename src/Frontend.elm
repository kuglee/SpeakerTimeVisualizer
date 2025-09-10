module Frontend exposing (Model, app)

import Browser.Events
import Browser.Navigation
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html
import Json.Decode as Decode
import Lamdera exposing (sendToBackend)
import Round
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
        , subscriptions = subscriptions
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
      , leftSideRatio = 0
      , rightSideRatio = 0
      , range = 100
      , avatarScale = 15
      , fankadeliSide = Left
      , theme = Light
      , clientId = ""
      }
    , Cmd.none
    )


type RatioOperation
    = Increment
    | Decrement


update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
update msg model =
    let
        updateLeftSideRatio operation =
            let
                newValue =
                    case operation of
                        Increment ->
                            min (model.leftSideRatio + 1) model.range

                        Decrement ->
                            max (model.leftSideRatio - 1) 0
            in
            ( { model | leftSideRatio = newValue }, sendToBackend (LeftSideRatioChanged newValue) )

        updateRightSideRatio operation =
            let
                newValue =
                    case operation of
                        Increment ->
                            min (model.rightSideRatio + 1) model.range

                        Decrement ->
                            max (model.rightSideRatio - 1) 0
            in
            ( { model | rightSideRatio = newValue }, sendToBackend (RightSideRatioChanged newValue) )
    in
    case msg of
        UrlChanged url ->
            ( { model | currentRoute = Route.fromUrl url }, Cmd.none )

        IncrementLeftSideRatio ->
            updateLeftSideRatio Increment

        DecrementLeftSideRatio ->
            updateLeftSideRatio Decrement

        IncrementRightSideRatio ->
            updateRightSideRatio Increment

        DecrementRightSideRatio ->
            updateRightSideRatio Decrement

        RangeChange newrange ->
            let
                newModel =
                    { model
                        | range = newrange
                        , leftSideRatio = min model.leftSideRatio newrange
                        , rightSideRatio = min model.rightSideRatio newrange
                    }
            in
            ( newModel
            , sendToBackend (RangeChanged newModel.range newModel.leftSideRatio newModel.rightSideRatio)
            )

        AvatarScaleChange newValue ->
            ( { model | avatarScale = newValue }, sendToBackend (AvatarScaleChanged newValue) )

        FankaDeliSideChange ->
            let
                newSide =
                    case model.fankadeliSide of
                        Left ->
                            Right

                        Right ->
                            Left
            in
            ( { model
                | fankadeliSide = newSide
              }
            , sendToBackend (FankaDeliSideChanged newSide)
            )

        ResetRatiosButtonTap ->
            let
                newModel =
                    { model
                        | leftSideRatio = 0
                        , rightSideRatio = 0
                    }
            in
            ( newModel
            , sendToBackend (ResetRatiosButtonTapped newModel.leftSideRatio newModel.rightSideRatio)
            )

        LeftArrowKeyTap ->
            updateLeftSideRatio Increment

        RightArrowKeyTap ->
            updateRightSideRatio Increment

        ShiftLeftArrowKeyTap ->
            updateLeftSideRatio Decrement

        ShiftRightArrowKeyTap ->
            updateRightSideRatio Decrement

        FNoop ->
            ( model, Cmd.none )

        ThemeChange theme ->
            ( { model | theme = theme }, sendToBackend (ThemeChanged theme) )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        LeftSideRatioNewValue newValue clientId ->
            ( { model | leftSideRatio = newValue, clientId = clientId }, Cmd.none )

        RightSideRatioNewValue newValue clientId ->
            ( { model | rightSideRatio = newValue, clientId = clientId }, Cmd.none )

        RangeNewValue range leftSideRatio rightSideRatio clientId ->
            ( { model
                | range = range
                , leftSideRatio = leftSideRatio
                , rightSideRatio = rightSideRatio
                , clientId = clientId
              }
            , Cmd.none
            )

        AvatarScaleNewValue newValue clientId ->
            ( { model | avatarScale = newValue, clientId = clientId }, Cmd.none )

        FankadeliSideNewValue newSideValue leftSideRatio rightSideRatio clientId ->
            ( { model
                | fankadeliSide = newSideValue
                , leftSideRatio = leftSideRatio
                , rightSideRatio = rightSideRatio
                , clientId = clientId
              }
            , Cmd.none
            )

        ResetRatiosNewValue leftSideRatio rightSideRatio clientId ->
            ( { model
                | leftSideRatio = leftSideRatio
                , rightSideRatio = rightSideRatio
                , clientId = clientId
              }
            , Cmd.none
            )

        ThemeNewValue theme clientId ->
            ( { model | theme = theme, clientId = clientId }, Cmd.none )


subscriptions : Model -> Sub FrontendMsg
subscriptions model =
    Sub.batch
        [ Browser.Events.onKeyDown keyDecoder
        ]


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

        backgroundColor =
            case model.theme of
                Light ->
                    rgb255 0xFF 0xFF 0xFF

                Dark ->
                    rgb255 0x00 0x00 0x00

        textColor =
            case model.theme of
                Light ->
                    rgb255 0x00 0x00 0x00

                Dark ->
                    rgb255 0xFF 0xFF 0xFF
    in
    column
        [ spacing 20
        , width fill
        , height fill
        , Background.color backgroundColor
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
                        , labelColor = textColor
                        }
                    , avatarView
                        { sideData =
                            rightSideData
                        , side = Right
                        , scale = model.avatarScale
                        , labelColor = textColor
                        }
                    ]
                )
            ]
            [ sideView
                { side = Left
                , range = model.range
                , ratio = model.leftSideRatio
                , color = leftSideData.color
                }
            , sideView
                { side = Right
                , range = model.range
                , ratio = model.rightSideRatio
                , color = rightSideData.color
                }
            ]
        ]


sideView : { side : Side, ratio : Int, range : Int, color : Color } -> Element msg
sideView { side, ratio, range, color } =
    row
        [ width (fillPortion 50)
        , height fill
        , spaceEvenly
        ]
        ([ el
            [ Background.color (rgba255 0x00 0x00 0x00 0)
            , width (fillPortion (range - ratio))
            , height fill
            ]
            Element.none
         , el
            [ Background.color color
            , width (fillPortion ratio)
            , height fill
            ]
            Element.none
         ]
            |> (case side of
                    Right ->
                        List.reverse

                    Left ->
                        identity
               )
        )


adminView : Model -> Element FrontendMsg
adminView model =
    column
        [ width fill
        , spacing 30
        , paddingXY 20 20
        ]
        [ column
            [ width fill
            , spacing 50
            ]
            [ row [ spacing 10 ]
                [ el
                    [ width fill
                    ]
                  <|
                    el
                        [ width (px 50)
                        , alignRight
                        ]
                    <|
                        text "Bal:"
                , sideControl
                    { decrementMsg = DecrementLeftSideRatio
                    , incrementMsg = IncrementLeftSideRatio
                    , ratio = model.leftSideRatio
                    , range = model.range
                    }
                ]
            , row [ spacing 10 ]
                [ el [ width (px 50) ] <|
                    text "Jobb:"
                , sideControl
                    { decrementMsg = DecrementRightSideRatio
                    , incrementMsg = IncrementRightSideRatio
                    , ratio = model.rightSideRatio
                    , range = model.range
                    }
                ]
            ]
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
            { onChange = round >> RangeChange
            , label =
                Input.labelAbove []
                    (text ("Skála: " ++ String.fromInt model.range ++ " lépés"))
            , min = 50
            , max = 500
            , step = Just 50
            , value = toFloat model.range
            , thumb =
                Input.defaultThumb
            }
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
        , Input.button
            [ Background.color (rgb255 0x90 0x90 0x90)
            , padding 10
            ]
            { onPress = Just FankaDeliSideChange
            , label =
                el
                    [ centerX
                    , centerY
                    ]
                <|
                    text "Oldalcsere"
            }
        , Input.radio
            [ padding 10
            , spacing 20
            ]
            { onChange = ThemeChange
            , selected = Just model.theme
            , label = Input.labelAbove [] (text "Téma")
            , options =
                [ Input.option Light (text "Világos")
                , Input.option Dark (text "Sötét")
                ]
            }
        , column []
            [ el [ height (px 200) ] <| Element.none
            , Input.button
                [ Background.color (rgb255 0x90 0x90 0x90)
                , padding 10
                ]
                { onPress = Just ResetRatiosButtonTap
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


sideControl : { decrementMsg : msg, incrementMsg : msg, ratio : Int, range : Int } -> Element msg
sideControl { decrementMsg, incrementMsg, ratio, range } =
    let
        percentage =
            let
                decimals =
                    if range > 100 then
                        2

                    else
                        0
            in
            Round.round decimals (toFloat ratio / toFloat range * 100)
    in
    row [ spacing 10 ]
        [ Input.button
            buttonStyle
            { onPress = Just decrementMsg
            , label =
                el
                    [ centerX
                    , centerY
                    ]
                <|
                    text "< "
            }
        , text (percentage ++ "%")
        , Input.button
            buttonStyle
            { onPress = Just incrementMsg
            , label =
                el
                    [ centerX
                    , centerY
                    ]
                <|
                    text ">"
            }
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
}
"""


avatarView : { sideData : SideData, side : Side, scale : Int, labelColor : Color } -> Element msg
avatarView { sideData, side, scale, labelColor } =
    let
        alignment =
            case side of
                Left ->
                    alignLeft

                Right ->
                    alignRight

        imageSize =
            px (scale * 10)
    in
    column
        [ spacing (round (4 * toFloat scale ^ 0.4))
        , padding (round (5 * toFloat scale ^ 0.4))
        ]
        [ el
            [ width imageSize
            , height imageSize
            , Border.rounded 10000
            , clip
            , alignment
            ]
          <|
            image
                [ width fill
                , height fill
                ]
                { src = sideData.imageSrc
                , description = ""
                }
        , el
            [ Font.size (round (10 * toFloat scale ^ 0.5))
            , Font.bold
            , Font.color labelColor
            , alignment
            ]
          <|
            text sideData.name
        ]


keyDecoder : Decode.Decoder FrontendMsg
keyDecoder =
    Decode.map2 Tuple.pair
        (Decode.field "key" Decode.string)
        (Decode.field "shiftKey" Decode.bool)
        |> Decode.andThen
            (\( key, shiftKey ) ->
                case ( key, shiftKey ) of
                    ( "ArrowLeft", False ) ->
                        Decode.succeed LeftArrowKeyTap

                    ( "ArrowLeft", True ) ->
                        Decode.succeed ShiftLeftArrowKeyTap

                    ( "ArrowRight", False ) ->
                        Decode.succeed RightArrowKeyTap

                    ( "ArrowRight", True ) ->
                        Decode.succeed ShiftRightArrowKeyTap

                    _ ->
                        Decode.fail "Not a key we care about"
            )
