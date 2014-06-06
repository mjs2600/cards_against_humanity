defmodule CardsAgainstHumanityTest do
  alias CardsAgainstHumanity.Deck
  alias CardsAgainstHumanity.User

  use ExUnit.Case

  @deck_json "[{'cardType': 'A', 'text': 'Test answer.'}, {'cardType': 'Q', 'text': 'Test question.'}]"

  test "creating a deck" do

    deck_pid = @deck_json |> Deck.build

    question_card = Deck.get_question_card(deck_pid)
    answer_card = Deck.get_answer_card(deck_pid)

    assert question_card.text == "Test question."
    assert answer_card.text == "Test answer."
  end

  test "creating a user" do
    user_pid = User.new("Test User", nil)
    assert Process.alive? user_pid
  end

  test "adding a card to a user" do
    user_pid = User.new("Test User", nil)
    deck_pid = @deck_json |> Deck.build

    question_card = Deck.get_question_card(deck_pid)
    User.recieve_card(user_pid, question_card)

    assert User.cards(user_pid) == [question_card]
  end

end
