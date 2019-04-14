defmodule Chorizo.WebApp.Guardian do
  @moduledoc """
  Defines how `Guardian` interacts with the application
  """

  @ttl_seconds 86_400 # 1 Day

  use Guardian, otp_app: :web_app,
    ttl: {@ttl_seconds, :seconds}

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    %{id: id}
  end

  def expires_in_seconds, do: @ttl_seconds
end
