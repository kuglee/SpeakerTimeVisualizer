module Evergreen.V9.Types exposing (..)

import Browser.Navigation
import Evergreen.V9.Route
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
    , currentRoute : Maybe Evergreen.V9.Route.Route
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


type alias BackendModel =
    { leftSideRatio : Int
    , rightSideRatio : Int
    , range : Int
    , avatarScale : Int
    , fankadeliSide : Side
    , homeTheme : Theme
    , adminTheme : Theme
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
    = ClientConnected Lamdera.SessionId Lamdera.ClientId
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
