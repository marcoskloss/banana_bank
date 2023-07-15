defmodule BananaBank.Users do
  defdelegate create(params), to: BananaBank.Users.Create, as: :call
  defdelegate get(id), to: BananaBank.Users.Get, as: :call
  defdelegate update(id), to: BananaBank.Users.Update, as: :call
  defdelegate delete(id), to: BananaBank.Users.Delete, as: :call
end
