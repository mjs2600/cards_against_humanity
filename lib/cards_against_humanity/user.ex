defmodule CardsAgainstHumanity.User do
  use ExActor.GenServer

  alias CardsAgainstHumanity.Deck

  defstruct name: "", cards: [], dealer: nil

  def new(name, dealer) do
    user = %__MODULE__{name: name, cards: [], dealer: dealer}
    {:ok, pid} = __MODULE__.start(user)

    pid
  end

  defcast recieve_card(card), state: user do
    new_cards = [card | user.cards]
    new_state(%__MODULE__{user | cards: new_cards })
  end

  defcall cards, state: user do
    reply(user.cards)
  end
end
