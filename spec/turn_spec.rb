require 'rspec'
require './lib/card'
require './lib/deck'
require './lib/player'
require './lib/turn'

RSpec.describe Turn do
  before do
    @card1 = Card.new(:heart, 'Jack', 11)
    @card2 = Card.new(:heart, '10', 10)
    @card3 = Card.new(:heart, '9', 9)
    @card4 = Card.new(:diamond, 'Jack', 11)
    @card5 = Card.new(:heart, '8', 8)
    @card6 = Card.new(:diamond, 'Queen', 12)
    @card7 = Card.new(:heart, '3', 3)
    @card8 = Card.new(:diamond, '2', 2)
    @cards = [@card1, @card2, @card3, @card4, @card5, @card6, @card7, @card8]
    @deck1 = Deck.new([@card1, @card2, @card5, @card8])
    @deck2 = Deck.new([@card3, @card4, @card6, @card7])
    @player1 = Player.new('Megan', @deck1)
    @player2 = Player.new('Aurora', @deck2)
    @turn = Turn.new(@player1, @player2)
  end

  it "exists" do
    expect(@turn).to be_an_instance_of Turn
  end

  it "has attributes" do
    expect(@turn.player1).to eq @player1
    expect(@turn.player2).to eq @player2
    expect(@turn.spoils_of_war).to eq []
  end

  context 'turn type' do 
    it "can return the winner of :basic turn" do
      winner = @turn.winner

      expect(@turn.type).to eq :basic
      expect(winner).to eq @player1
      expect(winner).not_to eq @player2
    end

    it "can return the winner of :war turn" do
      # switched cards 4 and 3 in deck2 to ensure for war
      deck1 = Deck.new([@card1, @card2, @card5, @card8])
      deck2 = Deck.new([@card4, @card3, @card6, @card7])
      player1 = Player.new('Megan', deck1)
      player2 = Player.new('Aurora', deck2)
      turn = Turn.new(player1, player2)
      winner = turn.winner

      expect(turn.type).to eq :war
      expect(winner).to eq player2 
      expect(winner).not_to eq player1
    end

    it "can return no winner of :'MAD' turn" do
      # set cards 5 and 6 to be the same at index position 2
      card5 = Card.new(:heart, '8', 8)
      card6 = Card.new(:diamond, '8', 8)
      deck1 = Deck.new([@card1, @card2, card5, @card8])
      deck2 = Deck.new([@card4, @card3, card6, @card7])
      player1 = Player.new('Megan', deck1)
      player2 = Player.new('Aurora', deck2)
      turn = Turn.new(player1, player2)

      expect(turn.type).to eq :mutually_assured_destruction 
      expect(turn.winner).to eq "There is no winner" 
    end
  end

  context 'pile cards into spoils of war' do 
    it "can return pile of cards for basic turn" do
      deck1 = Deck.new([@card1])
      deck2 = Deck.new([@card2])
      player1 = Player.new('Megan', deck1)
      player2 = Player.new('Aurora', deck2)
      turn = Turn.new(player1, player2)
      cards = [@card1, @card2]

      turn.winner
      turn.pile_cards

      expect(turn.spoils_of_war).to eq cards
      expect(player1.deck.cards).to eq []
      expect(player2.deck.cards).to eq []
    end

    it "can return pile of cards for war turn" do
      # set up decks to hit war
      deck1 = Deck.new([@card1, @card2, @card5, @card7])
      deck2 = Deck.new([@card4, @card3, @card6, @card8])
      player1 = Player.new('Megan', deck1)
      player2 = Player.new('Aurora', deck2)
      turn = Turn.new(player1, player2)
      cards = [@card1, @card2, @card5, @card4, @card3, @card6]

      turn.winner
      turn.pile_cards

      expect(turn.spoils_of_war).to eq cards 
      expect(player1.deck.cards).to eq [@card7] 
      expect(player2.deck.cards).to eq [@card8] 
    end

    it "can return pile of cards for 'MAD' turn" do
      # set up decks to hit war and MAD
      card5 = Card.new(:heart, 'Queen', 12)
      card6 = Card.new(:diamond, 'Queen', 12)
      deck1 = Deck.new([@card1, @card2, card5, @card7])
      deck2 = Deck.new([@card4, @card3, card6, @card8])
      player1 = Player.new('Megan', deck1)
      player2 = Player.new('Aurora', deck2)
      turn = Turn.new(player1, player2)
      winner = turn.winner

      turn.winner
      turn.pile_cards

      expect(turn.spoils_of_war).to eq [] 
      expect(player1.deck.cards).to eq [@card7] 
      expect(player2.deck.cards).to eq [@card8] 
    end
  end

  context 'award spoils' do
    it "awards the spoils to the victor for bacic turn" do
      deck1 = Deck.new([@card1])
      deck2 = Deck.new([@card2])
      player1 = Player.new('Megan', deck1)
      player2 = Player.new('Aurora', deck2)
      turn = Turn.new(player1, player2)
      winner = turn.winner
      cards = [@card1,@card2]

      turn.pile_cards

      expect(turn.spoils_of_war.count).to eq 2

      turn.award_spoils(winner)

      expect(turn.spoils_of_war.count).to eq 0
      expect(player1.deck.cards.count).to eq 2
      expect(player2.deck.cards).to eq [] 
    end

    it "awards the spoils to the victor for war turn" do
      # set up the decks to hit war 
      deck1 = Deck.new([@card1, @card2, @card5, @card7])
      deck2 = Deck.new([@card4, @card3, @card6, @card8])
      player1 = Player.new('Megan', deck1)
      player2 = Player.new('Aurora', deck2)
      turn = Turn.new(player1, player2)
      winner = turn.winner

      turn.pile_cards

      expect(turn.spoils_of_war.count).to eq 6 
      
      turn.award_spoils(winner)
      
      expect(turn.spoils_of_war.count).to eq 0 
      expect(player1.deck.cards).to eq [@card7] 
      expect(player2.deck.cards.count).to eq 7 
    end

    it "discards the spoils because there is no winner" do
      # set up decks to hit war and MAD 
      card5 = Card.new(:heart, '8', 8)
      card6 = Card.new(:diamond, '8', 8)
      deck1 = Deck.new([@card1, @card2, card5, @card7])
      deck2 = Deck.new([@card4, @card3, card6, @card8])
      player1 = Player.new('Megan', deck1)
      player2 = Player.new('Aurora', deck2)
      turn = Turn.new(player1, player2)

      turn.pile_cards

      expect(player1.deck.cards).to eq([@card7])
      expect(player2.deck.cards).to eq([@card8])
    end
  end
end