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
    ( { counter = 50
      , incrementAmount = 1
      , isCenterLineVisible = False
      , avatarScale = 15
      , fankadeliSide = Left
      }
    , Cmd.none
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        ClientConnected sessionId clientId ->
            ( model
            , Cmd.batch
                [ sendToFrontend clientId <| CounterNewValue model.counter clientId
                , sendToFrontend clientId <| IncrementAmountNewValue model.incrementAmount clientId
                , sendToFrontend clientId <| IsCenterLineVisibleNewValue model.isCenterLineVisible clientId
                , sendToFrontend clientId <| AvatarScaleNewValue model.avatarScale clientId
                , sendToFrontend clientId <| FankadeliSideNewValue model.fankadeliSide model.counter clientId
                ]
            )

        Noop ->
            ( model, Cmd.none )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        CounterChanged value ->
            ( { model | counter = value }, broadcast (CounterNewValue value clientId) )

        IncrementAmountChanged value ->
            ( { model | incrementAmount = value }, broadcast (IncrementAmountNewValue value clientId) )

        IsCenterLineVisibleChanged value ->
            ( { model | isCenterLineVisible = value }, broadcast (IsCenterLineVisibleNewValue value clientId) )

        AvatarScaleChanged value ->
            ( { model | avatarScale = value }, broadcast (AvatarScaleNewValue value clientId) )

        FankaDeliSideChanged side counter ->
            ( { model
                | fankadeliSide = side
                , counter = counter
              }
            , broadcast (FankadeliSideNewValue side counter clientId)
            )


subscriptions model =
    Sub.batch
        [ Lamdera.onConnect ClientConnected
        ]
