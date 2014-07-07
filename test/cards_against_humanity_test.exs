defmodule CardsAgainstHumanityTest do
  alias CardsAgainstHumanity.Dealer
  alias CardsAgainstHumanity.Deck
  alias CardsAgainstHumanity.User
  alias CardsAgainstHumanity.Card

  use ExUnit.Case

  @deck_json "[{'cardType': 'A', 'text': 'Test answer.'}, {'cardType': 'Q', 'text': 'Test question.'}]"

  test "creating a deck" do
    {:ok, deck_pid} = @deck_json |> Deck.build

    question_card = Deck.get_question_card(deck_pid)
    answer_card = Deck.get_answer_card(deck_pid)

    assert question_card.text == "Test question."
    assert answer_card.text == "Test answer."
  end

  test "creating a user" do
    {:ok, user_pid} = User.new("Test User")
    assert Process.alive? user_pid
  end

  test "creating a deck from the file" do
    {:ok, deck_pid} = Deck.new
    question_card = Deck.get_question_card(deck_pid)
    answer_card = Deck.get_answer_card(deck_pid)

    assert question_card.__struct__ == Card
    assert answer_card.__struct__ == Card
  end

  test "creating a dealer" do
    {:ok, dealer_pid} = Dealer.new
    assert Dealer.get(dealer_pid).users == []
  end

  test "adding a user to a dealer" do
    {:ok, dealer_pid} = Dealer.new
    {:ok, user_pid} = User.new("Test User")
    Dealer.add_user(dealer_pid, user_pid)
    assert Dealer.get(dealer_pid).users == [user_pid]
  end

  test "deal cards" do
    {:ok, dealer_pid} = Dealer.new
    {:ok, user_pid} = User.new("Test User")
    Dealer.add_user(dealer_pid, user_pid)
    Dealer.deal(dealer_pid)
    user = Dealer.get(dealer_pid).users |> List.first
    number_of_cards = user |> User.cards |> Enum.count
    assert number_of_cards == 7
  end
end
