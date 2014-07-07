defmodule CardsAgainstHumanity.Deck do
  use ExActor.GenServer
  alias CardsAgainstHumanity.Card
  defstruct question_cards: [], answer_cards: []

  def new do
    "cards.json"
    |> File.read!
    |> build
  end

  def build(json) do
    {:ok, data} = JSEX.decode(json)

    {question_cards, answer_cards} = data
    |> Stream.map(&Card.build(&1))
    |> Enum.shuffle
    |> Enum.partition(&question_card?/1)

    deck = %__MODULE__{question_cards: question_cards, answer_cards: answer_cards}
    start(deck)
  end

  defp question_card?(card) do
    card.type == "Q"
  end

  defcall get_question_card, state: deck do
    [question_card|updated_question_cards] = deck.question_cards
    new_deck = %__MODULE__{deck | question_cards: updated_question_cards}

    set_and_reply(new_deck, question_card)
  end

  def get_answer_card(pid) do
    pid
    |> get_answer_cards(1)
    |> List.first
  end

  defcall get_answer_cards(count), state: deck do
    answer_cards = Enum.take deck.answer_cards, count
    updated_answer_cards = Enum.drop deck.answer_cards, count
    new_deck = %__MODULE__{deck | answer_cards: updated_answer_cards}

    set_and_reply(new_deck, answer_cards)
  end

end
