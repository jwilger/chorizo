module Main exposing (main)

import Debug exposing (log)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Encode as Encode
import Json.Decode exposing (Decoder, map3, field, string)

main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }

type alias Model =
  { loginForm : LoginFormModel
  , loggedIn : Bool
  , authToken : String
  }

type alias LoginFormModel =
  { email : String
  , password : String
  , error : String
  }

type Msg
  = Email String
  | Password String
  | Submit
  | AuthenticationResponseAvailable (Result Http.Error AuthenticationResponse)

type alias AuthenticationResponse =
  { result : String
  , message : String
  , token : String
  }

init : () -> (Model, Cmd Msg)
init _ =
  (initModel, Cmd.none)

initModel : Model
initModel =
  { loginForm = { email = "",
                  password = "",
                  error = ""},
    loggedIn = False,
    authToken = "" }

setLoginForm : (LoginFormModel -> LoginFormModel) -> Model -> Model
setLoginForm fn model =
  {model | loginForm = fn model.loginForm}

setLoginFormEmail : String -> LoginFormModel -> LoginFormModel
setLoginFormEmail email loginForm =
  {loginForm | email = email}

setLoginFormPassword : String -> LoginFormModel -> LoginFormModel
setLoginFormPassword password loginForm =
  {loginForm | password = password}

setLoginFormError : String -> LoginFormModel -> LoginFormModel
setLoginFormError error loginForm =
  {loginForm | error = error}

setAuthToken : String -> Model -> Model
setAuthToken token model =
  {model | authToken = token}

isLoggedIn : Model -> Bool
isLoggedIn model =
  String.length model.authToken > 0

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Email email ->
      model
      |> (setLoginForm <| setLoginFormEmail email)
      |> \n -> (n, Cmd.none)

    Password password ->
      model
      |> (setLoginForm <| setLoginFormPassword password)
      |> \n -> (n, Cmd.none)

    Submit ->
      model
      |> (setLoginForm <| setLoginFormEmail "")
      |> (setLoginForm <| setLoginFormPassword "")
      |> (setLoginForm <| setLoginFormError "")
      |> \n -> (n, postCredentials model.loginForm)

    AuthenticationResponseAvailable response ->
      case log "response" response of
        Ok data ->
          (handleAuthenticationResponse model data, Cmd.none)

        Err error ->
          model
          |> (setLoginForm <| setLoginFormError "Server error. Please try again later.")
          |> \n -> (n, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

view : Model -> Html Msg
view model =
  if isLoggedIn model
    then text ("Hello World! " ++ model.authToken)
    else loginPromptView model.loginForm

encodeLoginForm : LoginFormModel -> Encode.Value
encodeLoginForm model =
  Encode.object
    [ ("email", Encode.string model.email)
    , ("password", Encode.string model.password)
    ]

authenticationResponseDecoder : Decoder AuthenticationResponse
authenticationResponseDecoder =
  map3 AuthenticationResponse
    (field "result" string)
    (field "message" string)
    (field "token" string)

handleAuthenticationResponse : Model -> AuthenticationResponse -> Model
handleAuthenticationResponse model data =
  case data.result of
    "success" ->
      model
      |> setAuthToken data.token
    _ ->
      model
      |> (setLoginForm <| setLoginFormError data.message)

postCredentials : LoginFormModel -> Cmd Msg
postCredentials model =
  Http.post
    { url = "/api/authenticate"
    , body = Http.jsonBody (encodeLoginForm model)
    , expect = Http.expectJson AuthenticationResponseAvailable authenticationResponseDecoder
    }

loginPromptView : LoginFormModel -> Html Msg
loginPromptView model =
  div [id "loginPrompt"] [
    h2 [] [text "Please Log In"],
    if String.length model.error > 0
      then div [class "error"] [text model.error]
      else text "",
    Html.form [id "myForm", onSubmit Submit] [
      input_field "Email" Email [type_ "email", required True, value model.email],
      input_field "Password" Password [type_ "password", required True, value model.password],

      button [
        type_ "submit",
        class "btn btn-primary"
        ] [text "Log In"]
    ]
  ]

input_field lbl updater attrs =
  div [class "form-group"] [
    label [] [
      text lbl,
      [ class "form-control",
        type_ "text",
        onInput updater ]
      |> \x -> List.concat [x, attrs]
      |> \y -> input y []
      ]
    ]
