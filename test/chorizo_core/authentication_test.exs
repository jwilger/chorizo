defmodule ChorizoCore.AuthenticationTest do
  use ExUnit.Case, async: true
  import Mox

  alias __MODULE__.{MockUsers, MockHasher}
  alias ChorizoCore.Entities.User

  setup_all do
    defmock(__MODULE__.MockUsers, for: ChorizoCore.Repositories.API)
    defmock(__MODULE__.MockHasher, for: ChorizoCore.Authentication.Hasher)
    []
  end

  setup :verify_on_exit!

  def authenticate_user(username: username, password: password) do
    ChorizoCore.Authentication.authenticate_user(
      username: username,
      password: password,
      users_repo: MockUsers,
      hasher: MockHasher
    )
  end

  describe "authenticate_user/1" do
    test "looks for a user with the matching username" do
      username = "bob"

      MockUsers
      |> expect(:first, fn username: ^username -> {:not_found, nil} end)

      authenticate_user(username: username, password: "whatever")
    end
  end

  describe "authenticate_user/1 when no matching user is found" do
    setup do
      MockUsers
      |> stub(:first, fn _ -> {:not_found, nil} end)
      []
    end

    test "returns a failed response" do
      assert {:failed, nil} =
        authenticate_user(username: "nope", password: "wev")
    end
  end

  describe "authenticate_user/1 when matching user is found" do
    setup :matching_user_found

    test "checks the password against the user's password hash",
    %{user: user} do
      password = "let me in"
      MockHasher
      |> expect(:check_pass, fn ^user, ^password -> {:ok, user} end)
      authenticate_user(username: user.username, password: password)
    end
  end

  describe "authenticate_user/1 when password is correct" do
    setup :matching_user_found
    setup :password_is_correct

    test "returns the authenticated user",
    %{user: user} do
      assert {:ok, ^user} =
        authenticate_user(username: user.username, password: "let me in")
    end
  end

  describe "authenticate_user/1 when password is incorrect" do
    setup :matching_user_found
    setup :password_is_incorrect

    test "returns a failed response",
    %{user: user} do
      assert {:failed, nil} =
        authenticate_user(username: user.username, password: "let me in")
    end
  end

  defp matching_user_found(_context) do
    user = User.new
    MockUsers
    |> stub(:first, fn _ -> {:ok, user} end)
    [user: user]
  end

  defp password_is_correct(_context) do
    MockHasher
    |> stub(:check_pass, fn user, _password -> {:ok, user} end)
    []
  end

  defp password_is_incorrect(_context) do
    MockHasher
    |> stub(:check_pass, fn _user, _password ->
      {:error, "something failed"}
    end)
    []
  end
end
