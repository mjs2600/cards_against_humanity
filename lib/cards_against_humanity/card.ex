defmodule CardsAgainstHumanity.Card do
  defstruct text: "", number_of_answers: 0, type: ""

  def build(card_data) do
    %CardsAgainstHumanity.Card{type:              card_data["cardType"],
                               number_of_answers: card_data["numAnswers"],
                               text:              card_data["text"]}
  end
end
