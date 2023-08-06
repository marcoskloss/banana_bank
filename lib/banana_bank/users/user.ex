defmodule BananaBank.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias BananaBank.Accounts.Account

  @required_update_params [:name, :email, :cep]
  @all_params [:password] ++ @required_update_params


  @except_json_params [:__meta__, :password, :password_hash]

  @derive {Jason.Encoder, except: @except_json_params}
  schema "users" do
    field :name, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :email, :string
    field :cep, :string

    has_one :account, Account

    timestamps()
  end

  def changeset_create(params) do
    %__MODULE__{}
    |> cast(params, @all_params)
    |> validate_required(@all_params)
    |> common_changeset_validations()
  end

  def changeset_update(user, params) do
    user
    |> cast(params, @all_params)
    |> validate_required(@required_update_params)
    |> common_changeset_validations()
  end

  defp common_changeset_validations(changeset) do
    changeset
    |> unique_constraint(:email)
    |> validate_length(:name, min: 3)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:cep, is: 8)
    |> validate_length(:password, min: 6)
    |> add_password_hash()
  end

  defp add_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password))
  end

  defp add_password_hash(changeset), do: changeset
end
