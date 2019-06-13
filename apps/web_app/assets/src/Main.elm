module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Element exposing (Element, el, text, column, spacing, centerY, padding, rgb255, centerX, alignRight, row, width, fill)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Url



--> Model


type alias Model =
  { loggedIn : Bool
  , emailInput : String
  , passwordInput : String
  , submitted : Bool
  , url : Url.Url
  , key : Nav.Key
  }



--> View


view : Model -> Browser.Document Msg
view model =
  { title = "Chorizo"
  , body =
      [ case model.url.path of
          "/" ->
            viewLogin model

          "/signup" ->
            viewSignup model

          _ ->
            Html.h1 [] [ Html.text "Whoops!" ]
      ]
  }

viewLogin : Model -> Html Msg
viewLogin model =
  Element.layout []
    (loginForm model)

viewSignup : Model -> Html Msg
viewSignup model =
  Element.layout []
    (signupForm model)

signupForm : Model -> Element Msg
signupForm model =
  text ("Welcome to " ++ model.url.path)

loginForm : Model -> Element Msg
loginForm model =
  column [ spacing 30, centerY, centerX]
    [ loginRow
    , Input.username []
        { onChange = EmailInputChanged
        , text = model.emailInput
        , placeholder = Just (Input.placeholder [] (text "email"))
        , label = Input.labelHidden "Email"
        }
    , Input.currentPassword []
        { onChange = PasswordInputChanged
        , text = model.passwordInput
        , placeholder = Just(Input.placeholder [] (text "password"))
        , label = Input.labelHidden "Email"
        , show = False
        }
    , if model.submitted
        then text "Submitting..."
        else Input.button []
          { onPress = Just SubmitLogin
          , label = (el 
            [ Background.color (rgb255 50 0 40)
            , Border.rounded 3
            , Font.color (rgb255 255 255 255)
            , padding 10
            ] (text "Login"))
          }
    ]

loginRow : Element Msg
loginRow =
  row [ width fill ]
    [ text "Login"
    , el [ centerX ] (text "or")
    , Element.link [ alignRight, Font.underline, Font.color (rgb255 0 0 255) ]
        { url = "/signup"
        , label = text "Sign up"
        }
    ]



--> Update


type Msg
  = UrlRequested Browser.UrlRequest
  | UrlChanged Url.Url
  | PasswordInputChanged String
  | EmailInputChanged String
  | SubmitLogin


update msg model =
  case msg of
    EmailInputChanged text ->
      ( { model | emailInput = text }, Cmd.none )

    PasswordInputChanged text ->
      ( { model | passwordInput = text }, Cmd.none )

    UrlRequested request ->
      case request of
        Browser.Internal url ->
          ( model, Nav.pushUrl model.key (Url.toString url) )

        Browser.External href ->
          ( model, Nav.load href )

    UrlChanged url ->
      ( { model | url = url }
      , Cmd.none
      )

    SubmitLogin ->
      ( { model | emailInput = "", passwordInput = "", submitted = True }
      , Cmd.none
      )


subscriptions model =
  Sub.none



--> Initialization


init : flags -> Url.Url -> Nav.Key -> ( Model, Cmd msg )
init flags url key =
  ( { loggedIn = False
    , emailInput = ""
    , passwordInput = ""
    , submitted = False
    , url = url
    , key = key
    }
  , Cmd.none
  )


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
