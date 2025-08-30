module Evergreen.V1.Types exposing (..)

import Browser.Navigation
import Evergreen.V1.Route
import Lamdera
import Url


type Side
    = Left
    | Right


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , currentRoute : Maybe Evergreen.V1.Route.Route
    , splitRatio : Int
    , incrementAmount : Int
    , isCenterLineVisible : Bool
    , avatarScale : Int
    , fankadeliSide : Side
    , clientId : String
    }


type alias BackendModel =
    { splitRatio : Int
    , incrementAmount : Int
    , isCenterLineVisible : Bool
    , avatarScale : Int
    , fankadeliSide : Side
    }


type FrontendMsg
    = UrlChanged Url.Url
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
    = ClientConnected Lamdera.SessionId Lamdera.ClientId
    | Noop


type ToFrontend
    = SplitRatioNewValue Int String
    | IncrementAmountNewValue Int String
    | IsCenterLineVisibleNewValue Bool String
    | AvatarScaleNewValue Int String
    | FankadeliSideNewValue Side Int String
