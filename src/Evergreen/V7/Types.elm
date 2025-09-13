module Evergreen.V7.Types exposing (..)

import Browser.Navigation
import Evergreen.V7.Route
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
    , currentRoute : Maybe Evergreen.V7.Route.Route
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
    = LeftSideRatioNewValue Int String
    | RightSideRatioNewValue Int String
    | RangeNewValue Int Int Int String
    | AvatarScaleNewValue Int String
    | FankadeliSideNewValue Side Int Int String
    | ResetRatiosNewValue Int Int String
    | HomeThemeNewValue Theme String
    | AdminThemeNewValue Theme String
    | BackendNewValues BackendModel String
    | IsAdminVisibleOnHomePageNewValue Bool
    | TFNoop
