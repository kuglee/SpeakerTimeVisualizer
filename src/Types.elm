module Types exposing (..)

import Browser.Navigation
import Element exposing (Color)
import Lamdera exposing (ClientId, SessionId)
import Route exposing (Route)
import Url exposing (Url)


type alias BackendModel =
    { leftSideRatio : Int
    , rightSideRatio : Int
    , incrementAmount : Int
    , avatarScale : Int
    , fankadeliSide : Side
    }


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , currentRoute : Maybe Route
    , leftSideRatio : Int
    , rightSideRatio : Int
    , incrementAmount : Int
    , avatarScale : Int
    , fankadeliSide : Side
    , clientId : String
    }


type FrontendMsg
    = UrlChanged Url
    | IncrementLeftSideRatio
    | IncrementRightSideRatio
    | LeftSideRatioChange String
    | RightSideRatioChange String
    | IncrementAmountChange String
    | AvatarScaleChange Int
    | FankaDeliSideChange
    | ResetRatiosButtonTap
    | FNoop


type ToBackend
    = LeftSideRatioChanged Int
    | RightSideRatioChanged Int
    | IncrementAmountChanged Int
    | AvatarScaleChanged Int
    | FankaDeliSideChanged Side
    | ResetRatiosButtonTapped Int Int


type BackendMsg
    = ClientConnected SessionId ClientId
    | Noop


type ToFrontend
    = LeftSideRatioNewValue Int String
    | RightSideRatioNewValue Int String
    | IncrementAmountNewValue Int String
    | AvatarScaleNewValue Int String
    | FankadeliSideNewValue Side Int Int String
    | ResetRatiosNewValue Int Int String


type alias SideData =
    { name : String
    , imageSrc : String
    , color : Color
    }


type Side
    = Left
    | Right
