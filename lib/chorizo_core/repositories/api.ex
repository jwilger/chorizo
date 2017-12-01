defmodule ChorizoCore.Repositories.API do
  @moduledoc """
  Behavior module for the Repositories API
  """

  @typedoc """
  The type of record stored by the repository
  """
  @type record :: struct()

  @typedoc """
  Returned by functions that successfully find a single result
  """
  @type found(type) :: {:ok, type}

  @typedoc """
  Returned by functions that successfully find multiple results
  """
  @type found_multi(type) :: {:ok, nonempty_list(type)}

  @typedoc """
  Returned by functions that execute successfully but do not find any records
  """
  @type not_found(type) :: {:not_found, type}

  @typedoc """
  Returned by functions that encounter an error during operation, e.g. if an
  attempt is made to insert an invalid record.
  """
  @type error :: {:error, term}

  @typedoc """
  Return value for functions that are expected to return at most 1 result
  """
  @type single_result(type) :: found(type) | not_found(nil) | error

  @typedoc """
  Return value for functions that are expected to return many results
  """
  @type multi_result(type) :: found_multi(type) | not_found([]) | error

  @typedoc """
  Search options used by the repository to filter results
  """
  @type search_options() :: keyword()

  @optional_callbacks first: 0

  @doc """
  Inserts `record` into the repository
  """
  @callback insert(record) :: single_result(record)

  @doc """
  Finds the first item in the repository that matches `search_options`
  """
  @callback first(search_options) :: single_result(record)

  @doc """
  Finds the first item in the repository
  """
  @callback first() :: single_result(record)

  @doc """
  Returns the number of items in the repository matching `search_options`
  """
  @callback count(search_options) :: single_result(integer)

  @doc """
  Returns the total number of items in the repository
  """
  @callback count() :: single_result(integer)
end
