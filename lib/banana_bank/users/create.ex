defmodule BananaBank.Users.Create do
  alias BananaBank.Users.User
  alias BananaBank.Repo
  alias BananaBank.ViaCep.Client, as: ViaCepClient

  def call(params) do
    with {:ok, _} <- ViaCepClient.verify_cep(params["cep"]) do
      params
      |> User.changeset_create()
      |> Repo.insert()
    end
  end
end
