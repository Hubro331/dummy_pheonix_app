defmodule Rumbl.Accounts do
  @moduledoc """
  Accounts Context
  """
  alias Rumbl.Accounts.User
  alias Rumbl.Repo

  @spec list_users :: list(User.t())
  def list_users do
    Repo.all(User)
  end

  @spec get_user!(integer()) :: User.t() | none()
  def get_user!(id) do
    Repo.get!(User, id)
  end

  @spec get_user(integer()) :: User.t() | nil
  def get_user(id) do
    Repo.get(User, id)
  end

  @spec get_user_by(map()) :: User.t() | nil
  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def change_registration(%User{} = user, params) do
    User.registration_changeset(user, params)
  end

  def create_user(attr \\ %{}) do
    %User{}
    |> User.changeset(attr)
    |> Repo.insert()
  end

  def authenticate_by_username_and_pass(username, given_pass) do
    user = get_user_by(%{username: username})
    cond do
      user && Pbkdf2.verify_pass(given_pass, user.password_hash) ->
        {:ok, user}
      user ->
        {:error, :unauthorized}
      true ->
        Pbkdf2.no_user_verify()
        {:error, :not_found}
    end
  end
end
