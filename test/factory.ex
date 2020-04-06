defmodule IdleTesting.Factory do
  use ExMachina.Ecto, repo: IdleTesting.Repo
  alias IdleTesting.User

  def user_factory do
    %User{}
  end
end
