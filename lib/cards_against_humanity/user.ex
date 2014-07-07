defmodule CardsAgainstHumanity.User do
  use ExActor.GenServer
  alias CardsAgainstHumanity.Deck
  defstruct name: "", cards: []
  @hand_size 7

  def new(name) do
    user = %__MODULE__{name: name, cards: []}
    start(user)
  end

  defcast get_cards(deck), state: user do
    cards_in_hand = user.cards |> Enum.count
    number_of_cards = @hand_size - cards_in_hand
    new_cards = Deck.get_answer_cards(deck, number_of_cards)
    |> Enum.concat(user.cards)
    new_state(%__MODULE__{user | cards: new_cards})
  end

  defcall cards, state: user do
    reply(user.cards)
  end
end
