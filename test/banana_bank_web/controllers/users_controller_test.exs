defmodule BananaBankWeb.UsersControllerTest do
  use BananaBankWeb.ConnCase

  import Mox

  alias BananaBank.Repo
  alias BananaBank.Users
  alias Users.User
  import BananaBank.UsersFixtures

  setup :verify_on_exit!

  describe "POST /api/users" do
    test "create user", %{conn: conn} do
      expect(BananaBank.ViaCep.ClientMock, :verify_cep, fn _cep ->
        {:ok, %{}}
      end)

      response =
        conn
        |> post(~p"/api/users", user_fixture(:data_only))
        |> json_response(:created)

      assert %{
        "data" => %{"id" => _id},
        "message" => _msg
      } = response
    end

    # One assertion for each %User{} key
    test "returns an error when the payload is invalid", %{conn: conn} do
      user_data = user_fixture(:data_only)

      invalid_payloads = for key <- Map.keys(user_data) do
        payload = Map.delete(user_data, key)
        {payload, key}
      end

      mock_calls = length(invalid_payloads)
      expect(BananaBank.ViaCep.ClientMock, :verify_cep, mock_calls, fn _cep ->
        {:ok, %{}}
      end)

      responses =
        invalid_payloads
        |> Enum.map(fn {payload, _} ->
          conn
          |> post(~p"/api/users", payload)
          |> json_response(:bad_request)
        end)

      invalid_payloads
      |> Enum.with_index()
      |> Enum.map(fn {invalid_payload, index} ->
        missing_key = elem(invalid_payload, 1) |> Atom.to_string()
        response = Enum.at(responses, index)

        assert %{"errors" => error} = response
        assert Map.has_key?(error, missing_key)
      end)
    end

    test "encrypt password", %{conn: conn} do
      expect(BananaBank.ViaCep.ClientMock, :verify_cep, fn _cep ->
        {:ok, %{}}
      end)

      user_data = user_fixture(:data_only)

      response =
        conn
        |> post(~p"/api/users", user_data)
        |> json_response(:created)

      created_user = response["data"]
      %{password_hash: password_hash} = Repo.get(User, created_user["id"])

      assert password_hash != user_data["password"]
    end
  end

  describe "DELETE /api/users" do
    test "delete user", %{conn: conn} do
      expect(BananaBank.ViaCep.ClientMock, :verify_cep, fn _cep ->
        {:ok, %{}}
      end)

      user_data = user_fixture(:data_only)
      {:ok, user } = Users.create(user_data)

      conn
      |> delete(~p"/api/users/#{user.id}")

      assert Repo.get(User, user.id) == nil
    end
  end
end
