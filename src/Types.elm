module Types exposing (..)

import Lamdera exposing (ClientId, SessionId)


type alias BackendModel =
    { counter : Int
    , incrementAmount : Int
    , isCenterLineVisible : Bool
    }


type alias FrontendModel =
    { counter : Int
    , incrementAmount : Int
    , isCenterLineVisible : Bool
    , clientId : String
    }


type FrontendMsg
    = Increment
    | Decrement
    | IncrementAmountChange String
    | IsCenterLineVisibleChange Bool
    | FNoop


type ToBackend
    = CounterChanged Int
    | IncrementAmountChanged Int
    | IsCenterLineVisibleChanged Bool


type BackendMsg
    = ClientConnected SessionId ClientId
    | Noop


type ToFrontend
    = CounterNewValue Int String
    | IncrementAmountNewValue Int String
    | IsCenterLineVisibleNewValue Bool String
