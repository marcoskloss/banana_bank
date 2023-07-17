defmodule BananaBank.Users.Create do
  alias BananaBank.Users.User
  alias BananaBank.Repo
  alias BananaBank.ViaCep

  def call(params) do
    with {:ok, _} <- ViaCep.get_client().verify_cep(params["cep"]) do
      params
      |> User.changeset_create()
      |> Repo.insert()
    end
  end
end
