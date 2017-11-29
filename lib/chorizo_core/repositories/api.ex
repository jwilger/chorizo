defmodule ChorizoCore.Repositories.API do
  @moduledoc """
  Behavior module for the Repositories API
  """

  @callback first(options :: keyword()) :: {:ok, struct()}
  @callback first(options :: keyword()) :: nil

  @callback count() :: {:ok, integer()}
end
