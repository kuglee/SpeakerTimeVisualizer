module Types exposing (..)

import Browser.Navigation
import Element exposing (Color)
import Lamdera exposing (ClientId, SessionId)
import Route exposing (Route)
import Url exposing (Url)


type alias BackendModel =
    { splitRatio : Int
    , incrementAmount : Int
    , isCenterLineVisible : Bool
    , avatarScale : Int
    , fankadeliSide : Side
    }


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , currentRoute : Maybe Route
    , splitRatio : Int
    , incrementAmount : Int
    , isCenterLineVisible : Bool
    , avatarScale : Int
    , fankadeliSide : Side
    , clientId : String
    }


type FrontendMsg
    = UrlChanged Url
    | Increment
    | Decrement
    | IncrementAmountChange String
    | IsCenterLineVisibleChange Bool
    | AvatarScaleChange Int
    | FankaDeliSideChange Side
    | ResetSplitRatioButtonTap
    | FNoop


type ToBackend
    = SplitRatioChanged Int
    | IncrementAmountChanged Int
    | IsCenterLineVisibleChanged Bool
    | AvatarScaleChanged Int
    | FankaDeliSideChanged Side Int


type BackendMsg
    = ClientConnected SessionId ClientId
    | Noop


type ToFrontend
    = SplitRatioNewValue Int String
    | IncrementAmountNewValue Int String
    | IsCenterLineVisibleNewValue Bool String
    | AvatarScaleNewValue Int String
    | FankadeliSideNewValue Side Int String


type alias SideData =
    { name : String
    , imageSrc : String
    , color : Color
    }


type Side
    = Left
    | Right
