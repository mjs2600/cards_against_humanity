defmodule CardsAgainstHumanity.Deck do
  alias CardsAgainstHumanity.Card

  defstruct question_cards: [], answer_cards: []

  def build(json) do
    {:ok, data} = JSEX.decode(json)
    {question_cards, answer_cards} = data
    |> Stream.map(&Card.build(&1))
    |> Enum.partition(&question_card/1)
    %CardsAgainstHumanity.Deck{question_cards: question_cards, answer_cards: answer_cards}
  end

  defp question_card(card) do
    card.type == "Q"
  end
end
