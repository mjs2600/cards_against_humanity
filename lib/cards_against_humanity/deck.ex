defmodule CardsAgainstHumanity.Deck do
  use ExActor.GenServer

  alias CardsAgainstHumanity.Card

  defstruct question_cards: [], answer_cards: []


  def build(json) do
    {:ok, data} = JSEX.decode(json)

    {question_cards, answer_cards} = data
    |> Stream.map(&Card.build(&1))
    |> Enum.shuffle
    |> Enum.partition(&question_card?/1)

    deck = %CardsAgainstHumanity.Deck{question_cards: question_cards, answer_cards: answer_cards}
    {:ok, pid} = CardsAgainstHumanity.Deck.start(deck)

    pid
  end

  defp question_card?(card) do
    card.type == "Q"
  end

  defcall get_question_card, state: deck do
    [question_card|updated_question_cards] = deck.question_cards
    new_deck = %CardsAgainstHumanity.Deck{deck | question_cards: updated_question_cards}

    set_and_reply(new_deck, question_card)
  end

  defcall get_answer_card, state: deck do
    [answer_card|updated_answer_cards] = deck.answer_cards
    new_deck = %CardsAgainstHumanity.Deck{deck | answer_cards: updated_answer_cards}

    set_and_reply(new_deck, answer_card)
  end
end
