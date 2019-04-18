module Login exposing (signupForm, loginForm, LoginMsg, LoginModel, initialModel, update)

import Element exposing (Element, el, text, column, spacing, centerY, padding, rgb255, centerX, alignRight, row, width, fill)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input

type LoginMsg
  = EmailInputChanged String
  | PasswordInputChanged String
  | SubmitLogin

type alias LoginModel =
  { emailInput : String
  , passwordInput : String
  , loggedIn : Bool
  , submitted : Bool
  }

initialModel : LoginModel
initialModel =
  { emailInput = ""
  , passwordInput = ""
  , loggedIn = False
  , submitted = False
  }

signupForm : Element LoginMsg
signupForm =
  text ("Welcome to the Sign up page!")

loginForm : LoginModel -> Element LoginMsg
loginForm model =
  column [ spacing 30, centerY, centerX]
    [ loginRow model.submitted
    , Input.email []
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

loginRow : Bool -> Element LoginMsg
loginRow submitted =
  row [ width fill ]
    [ text (if submitted
        then "Submitting..."
        else "Login")
    , el [ centerX ] (text "or")
    , Element.link [ alignRight, Font.underline, Font.color (rgb255 0 0 255) ]
        { url = "/signup"
        , label = text "Sign up"
        }
    ]

update : LoginMsg -> LoginModel -> (LoginModel, Cmd LoginMsg)
update msg model =
  case msg of
    EmailInputChanged text ->
      ( { model | emailInput = text }, Cmd.none )

    PasswordInputChanged text ->
      ( { model |  passwordInput = text }, Cmd.none )

    SubmitLogin ->
      ( { model | emailInput = "", passwordInput = "", submitted = True }
      , Cmd.none
      )
