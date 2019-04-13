defmodule Chorizo.WebApp.Guardian.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :web_app,
    error_handler: Chorizo.WebApp.Guardian.ErrorHandler,
    module: Chorizo.WebApp.Guardian

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
end
