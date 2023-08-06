defmodule BananaBank.UsersFixtures do
  alias BananaBank.Users.User
  alias BananaBank.Repo

  @default_user %{
    name: "John Doe",
    email: "john@mail.com",
    cep: "95095230",
    password: "!@#!@#"
  }

  def user_fixture(), do: user_fixture(@default_user)

  def user_fixture(:data_only), do: @default_user

  def user_fixture(params) do
    changeset = User.changeset_create(params)
    {:ok, user } = Repo.insert(changeset)
    user
  end
end
