module Types exposing (..)

import Browser.Navigation
import Element exposing (Color)
import Lamdera exposing (ClientId, SessionId)
import Route exposing (Route)
import Url exposing (Url)


type alias BackendModel =
    { leftSideRatio : Int
    , rightSideRatio : Int
    , range : Int
    , avatarScale : Int
    , fankadeliSide : Side
    , theme : Theme
    }


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , currentRoute : Maybe Route
    , leftSideRatio : Int
    , rightSideRatio : Int
    , range : Int
    , avatarScale : Int
    , fankadeliSide : Side
    , theme : Theme
    , clientId : String
    }


type FrontendMsg
    = UrlChanged Url
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


type BackendMsg
    = ClientConnected SessionId ClientId
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


type alias SideData =
    { name : String
    , imageSrc : String
    , color : Color
    }


type Side
    = Left
    | Right


type Theme
    = Light
    | Dark
