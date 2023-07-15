defmodule BananaBank.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @required_params [:name, :email, :cep]
  @required_params_with_password [:password] ++ @required_params


  @except_json_params [:__meta__, :password, :password_hash]

  @derive {Jason.Encoder, except: @except_json_params}
  schema "users" do
    field :name, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :email, :string
    field :cep, :string

    timestamps()
  end

  def changeset_create(params) do
    %__MODULE__{}
    |> cast(params, @required_params_with_password)
    |> validate_required(@required_params_with_password)
    |> common_changeset_validations()
  end

  def changeset_update(user, params) do
    user
    |> cast(params, @required_params_with_password)
    |> validate_required(@required_params)
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
