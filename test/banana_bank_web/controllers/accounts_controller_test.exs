defmodule BananaBankWeb.AccountsControllerTest do
  use BananaBankWeb.ConnCase
  import BananaBank.UsersFixtures

  describe "POST /api/accounts" do
    test "create account", %{conn: conn} do
      user = user_fixture()

      account = %{
        "user_id" => user.id,
        "balance" => 0,
      }

      response =
        conn
        |> post(~p"/api/accounts", account)
        |> json_response(:created)

      assert response["data"]["id"]
    end

    test "can't create account with invalid user", %{conn: conn} do
      account = %{
        "user_id" => 42,
        "balance" => 0,
      }

      response =
        conn
        |> post(~p"/api/accounts", account)
        |> json_response(:bad_request)

      assert %{"errors" => errors} = response
      assert errors["user_id"]
    end

    test "can't create account with negative balance", %{conn: conn} do
      user = user_fixture()

      account = %{
        "user_id" => user.id,
        "balance" => -1,
      }

      response =
        conn
        |> post(~p"/api/accounts", account)
        |> json_response(:bad_request)

      assert %{"errors" => errors} = response
      assert errors["balance"]
    end
  end
end
