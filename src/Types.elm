module Types exposing (..)

import Browser.Navigation
import Lamdera exposing (ClientId, SessionId)
import Route exposing (Route)
import Url exposing (Url)


type alias BackendModel =
    { counter : Int
    , incrementAmount : Int
    , isCenterLineVisible : Bool
    , avatarScale : Int
    }


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , currentRoute : Maybe Route
    , counter : Int
    , incrementAmount : Int
    , isCenterLineVisible : Bool
    , avatarScale : Int
    , clientId : String
    }


type FrontendMsg
    = UrlChanged Url
    | Increment
    | Decrement
    | IncrementAmountChange String
    | IsCenterLineVisibleChange Bool
    | AvatarScaleChange Int
    | FNoop


type ToBackend
    = CounterChanged Int
    | IncrementAmountChanged Int
    | IsCenterLineVisibleChanged Bool
    | AvatarScaleChanged Int


type BackendMsg
    = ClientConnected SessionId ClientId
    | Noop


type ToFrontend
    = CounterNewValue Int String
    | IncrementAmountNewValue Int String
    | IsCenterLineVisibleNewValue Bool String
    | AvatarScaleNewValue Int String
