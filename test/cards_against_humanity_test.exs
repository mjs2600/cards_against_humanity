defmodule CardsAgainstHumanityTest do
  alias CardsAgainstHumanity.Deck
  use ExUnit.Case

  test "creating a deck" do
    deck_json = "[{'cardType': 'A', 'text': 'Test answer.'}, {'cardType': 'Q', 'text': 'Test question.'}]"

    deck_pid = deck_json
    |> Deck.build

    question_card = Deck.get_question_card(deck_pid)
    answer_card = Deck.get_answer_card(deck_pid)

    assert question_card.text == "Test question."
    assert answer_card.text == "Test answer."
  end
end
