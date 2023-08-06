defmodule BananaBankWeb.AccountsController do
  use BananaBankWeb, :controller

  alias BananaBank.Accounts

  action_fallback BananaBankWeb.FallbackController

  def create(conn, params) do
    with {:ok, account } <- Accounts.create(params) do
      conn
      |> put_status(:created)
      |> render(:create, account: account)
    end
  end
end
