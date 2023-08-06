defmodule BananaBank.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  alias BananaBank.Users
  alias Users.User

  @required_params [:balance, :user_id]

  schema "accounts" do
    field :balance, :decimal

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(account \\ %__MODULE__{}, params) do
    account
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_number(:balance, greater_than_or_equal_to: 0)
    |> validate_user_fkey()
  end

  # we can't use foreign_key_constraint/3 because of https://github.com/elixir-sqlite/ecto_sqlite3/issues/42
  defp validate_user_fkey(%Ecto.Changeset{valid?: true} = changeset) do
    changeset
    |> validate_change(:user_id, fn :user_id, user_id ->
      case Users.get(user_id) do
        {:ok, _user}      -> []
        {:error, _reason} -> [user_id: "Usuário associado a conta não foi encontrado"]
      end
    end)
  end

  defp validate_user_fkey(changeset), do: changeset
end
