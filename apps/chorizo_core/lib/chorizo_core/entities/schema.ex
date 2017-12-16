defmodule ChorizoCore.Entities.Schema do
  @moduledoc """
  Use this to add Ecto Schemas to entities in this project.

  Instead of putting `use Ecto.Schema` in an entity, use the code `use
  ChorizoCore.Entities.Schema` instead. Doing so will ensure that all entities
  are using UUIDs for their primary key fields.
  """

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
    end
  end
end
