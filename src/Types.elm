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
    , homeTheme : Theme
    , adminTheme : Theme
    }


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , currentRoute : Maybe Route
    , leftSideRatio : Int
    , rightSideRatio : Int
    , range : Int
    , avatarScale : Int
    , fankadeliSide : Side
    , homeTheme : Theme
    , adminTheme : Theme
    , isAdminVisibleOnHomePage : Bool
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
    | HomeThemeChange Theme
    | AdminThemeChange Theme
    | ToggleAdminPanelOnHomePageButtonTap
    | FNoop


type ToBackend
    = LeftSideRatioChanged Int
    | RightSideRatioChanged Int
    | RangeChanged Int Int Int
    | AvatarScaleChanged Int
    | FankaDeliSideChanged Side
    | ResetRatiosButtonTapped Int Int
    | HomeThemeChanged Theme
    | AdminThemeChanged Theme
    | ToggleAdminPanelOnHomePageButtonTapped Bool
    | TBNoop


type BackendMsg
    = ClientConnected SessionId ClientId
    | Noop


type ToFrontend
    = LeftSideRatioNewValue Int
    | RightSideRatioNewValue Int
    | RangeNewValue Int Int Int
    | AvatarScaleNewValue Int
    | FankadeliSideNewValue Side Int Int
    | ResetRatiosNewValue Int Int
    | HomeThemeNewValue Theme
    | AdminThemeNewValue Theme
    | BackendNewValues BackendModel
    | IsAdminVisibleOnHomePageNewValue Bool
    | TFNoop


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
