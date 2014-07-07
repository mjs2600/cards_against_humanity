defmodule CardsAgainstHumanity.Dealer do
  use ExActor.GenServer
  alias CardsAgainstHumanity.Deck
  alias CardsAgainstHumanity.User
  @derive [Access]
  defstruct deck: nil, users: []

  def new(users \\ []) do
    {:ok, deck_pid} = Deck.new
    dealer = %__MODULE__{deck: deck_pid, users: users}
    __MODULE__.start_link(dealer)
  end

  defcall get, state: dealer do
    reply dealer
  end

  defcast add_user(user_pid), state: dealer do
    dealer
    |> update_in([:users], &([user_pid | &1]))
    |> new_state
  end

  defcast deal(), state: dealer do
    for user <- dealer.users do
      User.get_cards(user, dealer.deck)
    end

    noreply
  end
end
