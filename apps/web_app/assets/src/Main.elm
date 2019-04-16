module Main exposing (main)

import Browser
import Browser.Navigation exposing (Key)
import Element exposing (Element, el, text, column, spacing, centerY, padding, rgb255, centerX)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Url exposing (Url)



--> Model


type alias Model =
  { loggedIn : Bool
  , emailInput : String
  , passwordInput : String
  , submitted : Bool
  }


initialModel : Model
initialModel =
  { loggedIn = False
  , emailInput = ""
  , passwordInput = ""
  , submitted = False
  }



--> View


view : Model -> Browser.Document Msg
view model =
  { title = "Chorizo"
  , body =
      [ Element.layout []
          (loginForm model)
      ]
  }

loginForm : Model -> Element Msg
loginForm model =
  column [ spacing 30, centerY, centerX]
    [ text "Login Please"
    , Input.email []
        { onChange = EmailInputChanged
        , text = model.emailInput
        , placeholder = Just (Input.placeholder [] (text "email"))
        , label = Input.labelHidden "Email"
        }
    , Input.newPassword []
        { onChange = PasswordInputChanged
        , text = model.passwordInput
        , placeholder = Just(Input.placeholder [] (text "password"))
        , label = Input.labelHidden "Email"
        , show = False
        }
    , Input.button []
        { onPress = Just SubmitLogin
        , label = (el 
          [ Background.color (rgb255 50 0 40)
          , Border.rounded 3
          , Font.color (rgb255 255 255 255)
          , padding 10
          ] (text "Login"))
        }
    ]


--> Update


type Msg
  = UrlRequested Browser.UrlRequest
  | UrlChanged Url
  | PasswordInputChanged String
  | EmailInputChanged String
  | SubmitLogin


update msg model =
  case msg of
    EmailInputChanged text ->
      ({ model | emailInput = text }, Cmd.none)

    PasswordInputChanged text ->
      ({ model | passwordInput = text }, Cmd.none)

    UrlRequested request ->
      (model, Cmd.none)

    UrlChanged url ->
      (model, Cmd.none)

    SubmitLogin ->
      ({ emailInput = "", passwordInput = "", loggedIn = False, submitted = True }, Cmd.none)


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
