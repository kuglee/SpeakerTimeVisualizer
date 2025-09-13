module Backend exposing (app, init)

import Lamdera exposing (ClientId, SessionId, broadcast, sendToFrontend)
import Types exposing (..)


type alias Model =
    BackendModel


app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = subscriptions
        }


init : ( Model, Cmd BackendMsg )
init =
    ( { leftSideRatio = 0
      , rightSideRatio = 0
      , range = 100
      , avatarScale = 15
      , fankadeliSide = Left
      , homeTheme = Light
      , adminTheme = Light
      }
    , Cmd.none
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        ClientConnected sessionId clientId ->
            ( model
            , sendToFrontend
                clientId
              <|
                BackendNewValues
                    model
                    clientId
            )

        Noop ->
            ( model, Cmd.none )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        LeftSideRatioChanged value ->
            ( { model | leftSideRatio = value }, broadcast (LeftSideRatioNewValue value clientId) )

        RightSideRatioChanged value ->
            ( { model | rightSideRatio = value }, broadcast (RightSideRatioNewValue value clientId) )

        RangeChanged range leftSideRatio rightSideRatio ->
            let
                newModel =
                    { model
                        | range = range
                        , leftSideRatio = leftSideRatio
                        , rightSideRatio = rightSideRatio
                    }
            in
            ( newModel
            , broadcast (RangeNewValue newModel.range newModel.leftSideRatio newModel.rightSideRatio clientId)
            )

        AvatarScaleChanged value ->
            ( { model | avatarScale = value }, broadcast (AvatarScaleNewValue value clientId) )

        FankaDeliSideChanged side ->
            let
                newModel =
                    { model
                        | leftSideRatio = model.rightSideRatio
                        , rightSideRatio = model.leftSideRatio
                    }
            in
            ( newModel
            , broadcast (FankadeliSideNewValue side newModel.leftSideRatio newModel.rightSideRatio clientId)
            )

        ResetRatiosButtonTapped leftSideRatio rightSideRatio ->
            let
                newModel =
                    { model
                        | leftSideRatio = leftSideRatio
                        , rightSideRatio = rightSideRatio
                    }
            in
            ( newModel
            , broadcast (ResetRatiosNewValue newModel.leftSideRatio newModel.rightSideRatio clientId)
            )

        HomeThemeChanged theme ->
            ( { model | homeTheme = theme }, broadcast (HomeThemeNewValue theme clientId) )

        AdminThemeChanged theme ->
            ( { model | adminTheme = theme }, broadcast (AdminThemeNewValue theme clientId) )

        TBNoop ->
            ( model, Cmd.none )


subscriptions model =
    Sub.batch
        [ Lamdera.onConnect ClientConnected
        ]
