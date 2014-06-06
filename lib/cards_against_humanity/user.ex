defmodule CardsAgainstHumanity.User do
  use ExActor.GenServer

  alias CardsAgainstHumanity.Deck

  defstruct name: "", cards: [], dealer: nil

  def new(name, dealer) do
    user = %CardsAgainstHumanity.User{name: name, cards: [], dealer: dealer}
    {:ok, pid} = CardsAgainstHumanity.User.start(user)

    pid
  end

  defcast recieve_card(card), state: user do
    new_cards = [card | user.cards]
    new_state(%CardsAgainstHumanity.User{user | cards: new_cards })
  end

  defcall cards, state: user do
    reply(user.cards)
  end
end
