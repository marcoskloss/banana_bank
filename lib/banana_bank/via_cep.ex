defmodule BananaBank.ViaCep do
  alias BananaBank.ViaCep.Client, as: ViaCepClient

  def get_client() do
    Application.get_env(:banana_bank, :via_cep_client, ViaCepClient)
  end
end
