module Route exposing (Route(..), fromUrl)

import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, map, oneOf, s)


type Route
    = AdminPanel


parser : Parser (Route -> a) a
parser =
    oneOf
        [ map AdminPanel (s "admin")
        ]


fromUrl : Url -> Maybe Route
fromUrl url =
    Parser.parse parser url
