defmodule CardsAgainstHumanityTest do
  alias CardsAgainstHumanity.Deck
  use ExUnit.Case

  test "creating a deck" do
    deck_json = "[{'cardType': 'A', 'text': 'Test answer.'}, {'cardType': 'Q', 'text': 'Test question.'}]"

    deck = deck_json
    |> Deck.build

    question_card = deck.question_cards
    |> List.first

    answer_card = deck.answer_cards
    |> List.first

    assert question_card.text == "Test question."
    assert answer_card.text == "Test answer."
  end
end
