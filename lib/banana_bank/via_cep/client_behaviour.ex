defmodule BananaBank.ViaCep.ClientBehaviour do
  @callback verify_cep(String.t()) :: {:ok, map()} | {:error, atom()}
end
