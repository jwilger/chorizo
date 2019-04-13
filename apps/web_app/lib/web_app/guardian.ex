defmodule Chorizo.WebApp.Guardian do
  use Guardian, otp_app: :web_app

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    %{id: id}
  end
end
