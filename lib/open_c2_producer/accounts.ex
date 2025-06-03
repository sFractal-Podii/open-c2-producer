defmodule OpenC2Producer.Accounts do
  alias OpenC2Producer.Accounts.User
  alias OpenC2Producer.Repo

  def create_user(user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def get_user(email) do
    User
    |> Repo.get_by(email: email)
  end
end
