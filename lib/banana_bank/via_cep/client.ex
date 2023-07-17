defmodule BananaBank.ViaCep.Client do
  use Tesla

  alias BananaBank.ViaCep.ClientBehaviour

  plug Tesla.Middleware.BaseUrl, "https://viacep.com.br/ws"
  plug Tesla.Middleware.JSON

  @behaviour ClientBehaviour

  @impl ClientBehaviour
  def verify_cep(cep) do
    get("/#{cep}/json")
    |> handle_response()
  end

  defp handle_response({:ok, %Tesla.Env{status: 200, body: %{"erro" => true}}}),
    do: {:error, :invalid_cep}

  defp handle_response({:ok, %Tesla.Env{status: 200, body: body}}), do: {:ok, body}

  defp handle_response({:ok, %Tesla.Env{status: 400}}), do: {:error, :invalid_cep}

  defp handle_response({:error, _}), do: {:error, :internal_server_error}
end
