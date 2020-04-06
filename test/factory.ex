defmodule IdleTesting.Factory do
  use ExMachina.Ecto, repo: IdleTesting.Repo
  alias IdleTesting.User

  def user_factory do
    %User{
      email: Faker.Internet.email(),
      favorite_number: Enum.random(1..100),
      first_name: Faker.Name.En.first_name(),
      last_name: Faker.Name.En.last_name()
    }
  end
end
