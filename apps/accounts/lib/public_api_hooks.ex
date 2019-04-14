defmodule Chorizo.PublicApiHooks do
  @moduledoc """
  Generate Behaviour callbacks from function specs in a module

  If you are using `Mox` in a project to mock/stub out dependencies for one of
  your APIs, you need to have defined the API as a `Behaviour` by using the
  `@callback` attribute to describe the API methods. Having to add an entirely
  seperate module to define the callback is often overfkill, and having to add a
  bunch of `@cqllback` attributes to the implementation module that already
  contains the function definitions and `@spec` attributes is tedious.

  By adding `@on_definition Chorizo.PublicApiHooks` to the top of your API
  implementation module, Elixir will now automatically copy any `@spec`
  attributes to a `@callback` attribute for public functions defined from that
  point on.
  """

  def __on_definition__(env, :def, name, args, _guards, _body) do
    Module.spec_to_callback(env.module, {name, length(args)})
  end
end
