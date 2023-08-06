defmodule BananaBankWeb.AccountsJSON do
  def create(%{account: account}) do
    %{
      message: "Conta criada com sucesso",
      data: data(account)
    }
  end

  defp data(account) do
    %{
      id: account.id,
      balance: account.balance
    }
  end
end
