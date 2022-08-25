require 'rspec'
require './lib/card'
require './lib/deck'

RSpec.describe Deck do
  before do 
    @card1 = Card.new(:diamond, 'Queen', 12)
    @card2 = Card.new(:spade, '3', 3)
    @card3 = Card.new(:heart, 'Ace', 14)
    @cards = [@card1, @card2, @card3]
    @deck = Deck.new(@cards)
  end 

  it "exists" do
    expect(@deck).to be_an_instance_of Deck
  end

  it "can return rank from array position" do
    expect(@deck.rank_of_card_at(0)).to eq 12
    expect(@deck.rank_of_card_at(2)).to eq 14
  end

  it "can return high ranking cards" do
    expect(@deck.high_ranking_cards).to eq [@card1,@card3]
  end

  it "can return percent high ranking cards" do
    expect(@deck.percent_high_ranking).to eq 66.67
  end

  it "can remove a card" do
    expect(@deck.remove_card).to eq @card1
    expect(@deck.cards).to eq [@card2,@card3]
  end

  it "can add a card" do
    card4 = Card.new(:club, '5', 5)

    @deck.add_card(card4)

    expect(@deck.cards).to eq [@card1,@card2,@card3,card4]
  end
end
