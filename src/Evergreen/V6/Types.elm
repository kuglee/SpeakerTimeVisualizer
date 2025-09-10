module Evergreen.V6.Types exposing (..)

import Browser.Navigation
import Evergreen.V6.Route
import Lamdera
import Url


type Side
    = Left
    | Right


type Theme
    = Light
    | Dark


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , currentRoute : Maybe Evergreen.V6.Route.Route
    , leftSideRatio : Int
    , rightSideRatio : Int
    , range : Int
    , avatarScale : Int
    , fankadeliSide : Side
    , theme : Theme
    , clientId : String
    }


type alias BackendModel =
    { leftSideRatio : Int
    , rightSideRatio : Int
    , range : Int
    , avatarScale : Int
    , fankadeliSide : Side
    , theme : Theme
    }


type FrontendMsg
    = UrlChanged Url.Url
    | IncrementLeftSideRatio
    | DecrementLeftSideRatio
    | IncrementRightSideRatio
    | DecrementRightSideRatio
    | RangeChange Int
    | AvatarScaleChange Int
    | FankaDeliSideChange
    | ResetRatiosButtonTap
    | LeftArrowKeyTap
    | RightArrowKeyTap
    | ShiftLeftArrowKeyTap
    | ShiftRightArrowKeyTap
    | ThemeChange Theme
    | FNoop


type ToBackend
    = LeftSideRatioChanged Int
    | RightSideRatioChanged Int
    | RangeChanged Int Int Int
    | AvatarScaleChanged Int
    | FankaDeliSideChanged Side
    | ResetRatiosButtonTapped Int Int
    | ThemeChanged Theme
    | TBNoop


type BackendMsg
    = ClientConnected Lamdera.SessionId Lamdera.ClientId
    | Noop


type ToFrontend
    = LeftSideRatioNewValue Int String
    | RightSideRatioNewValue Int String
    | RangeNewValue Int Int Int String
    | AvatarScaleNewValue Int String
    | FankadeliSideNewValue Side Int Int String
    | ResetRatiosNewValue Int Int String
    | ThemeNewValue Theme String
    | BackendNewValues BackendModel String
    | TFNoop
