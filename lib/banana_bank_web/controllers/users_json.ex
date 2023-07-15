defmodule BananaBankWeb.UsersJSON do
  def create(%{user: user}) do
    %{
      message: "User criado com sucesso",
      data: data(user)
    }
  end

  def get(%{user: user}), do: %{data: user}
  def update(%{user: user}), do: %{data: user}

  defp data(user) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      cep: user.cep,
    }
  end
end
