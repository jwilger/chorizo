module Main exposing (main)

import Browser
import Browser.Navigation exposing (Key)
import Element exposing (Element, el, text)
import Url exposing (Url)



--> Model


type alias Model =
    { loggedIn : Bool }


initialModel : Model
initialModel =
    { loggedIn = False }



--> View


view : Model -> Browser.Document Msg
view model =
    { title = "Chorizo"
    , body =
        [ Element.layout []
            (el [] (text "Hello, World!"))
        ]
    }



--> Update


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url


update msg model =
    ( model, Cmd.none )


subscriptions model =
    Sub.none



--> Initialization


init : flags -> Url -> Key -> ( Model, Cmd msg )
init flags url key =
    ( initialModel, Cmd.none )


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = UrlRequested
        , onUrlChange = UrlChanged
        }
