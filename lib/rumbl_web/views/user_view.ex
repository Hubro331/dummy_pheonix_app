defmodule RumblWeb.UserView do
  use RumblWeb, :view

  alias Rumbl.Accounts.User

  @spec first_name(%Rumbl.Accounts.User{:name => binary}) :: String.t()
  def first_name(%User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end
end
