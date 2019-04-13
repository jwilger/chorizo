defmodule Chorizo.WebApp.Guardian.SecretFetcher do
  use Guardian.Token.Jwt.SecretFetcher

  def fetch_signing_secret(impl_mod, opts) do
    fetch_application_secret(impl_mod, opts)
  end

  def fetch_verifying_secret(impl_mod, _token_headers, opts) do
    fetch_application_secret(impl_mod, opts)
  end

  defp fetch_application_secret(mod, opts) do
    opts
    |> Keyword.get(:secret)
    |> get_configured_value(mod)
    |> resolve_configured_value()
  end

  defp get_configured_value(opt, mod) do
    Guardian.Config.resolve_value(opt) || apply(mod, :config, [:secret_key])
  end

  defp resolve_configured_value(nil), do: {:error, :secret_not_found}
  defp resolve_configured_value({:system, env_var}),
    do: fetch_secret_from_env(env_var)
  defp resolve_configured_value(value) when is_binary(value), do: {:ok, value}

  defp fetch_secret_from_env(env_var) do
    case System.get_env(env_var) do
      v when is_binary(v) -> {:ok, v}
      _ -> {:error, :secret_not_found}
    end
  end
end
