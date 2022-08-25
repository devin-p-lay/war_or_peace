require './lib/card'
require './lib/deck'
require './lib/player'
require './lib/turn'

class Game
  def initialize
    @full_deck = []
    create_deck
    shuffle_and_deal
    @player1 = Player.new('Megan', @deck1)
    @player2 = Player.new('Aurora', @deck2)
    @turn = Turn.new(@player1, @player2)
    intro
  end

  def create_deck
    suits = [:spade, :club, :diamond, :heart]
    ranks_and_values = {
      '2' => 2,
      '3' => 3,
      '4' => 4,
      '5' => 5,
      '6' => 6,
      '7' => 7,
      '8' => 8,
      '9' => 9,
      '10' => 10,
      'jack' => 11,
      'queen' => 12,
      'king' => 13,
      'ace' => 14
    }

    suits.flat_map do |suit|
      ranks_and_values.map do |rank, value|
        @full_deck << Card.new(suit, rank, value)
      end
    end
  end

  def shuffle_and_deal
    @full_deck.shuffle!
    @deck1 = Deck.new(@full_deck[0..25])
    @deck2 = Deck.new(@full_deck[26..51])
  end

  
  def intro
    p "Welcome to War! (or Peace) This game will be played with 52 cards."
    p "The players today are Megan and Aurora."
    p "Type 'GO' to start the game!"
    p "------------------------------------------------------------------"
    response = gets.chomp
    if response.downcase != 'go'
      intro
    else
      play_game
    end
  end

  def play_game
    counter = 0
    until @turn.player1.has_lost? || @turn.player2.has_lost? || counter == 1000
      turn = Turn.new(@player1, @player2)
      counter += 1
      type = turn.type
      winner = turn.winner 
      turn.pile_cards
      turn_message(counter, winner, type, turn)
      check_for_winner(counter, turn)
    end
  end

  def turn_message(counter, winner, type, turn)
    if type == :mutually_assured_destruction
      p "Turn #{counter}: ** Mutually Assured Destruction ** 6 cards removed from play"
      p "#{@player1.name}:#{@player1.deck.cards.count} | #{@player2.name}:#{@player2.deck.cards.count}"
    elsif type == :war 
      turn.award_spoils(winner)
      p "Turn #{counter}: WAR - #{winner.name} won 6 cards"
      p "#{@player1.name}:#{@player1.deck.cards.count} | #{@player2.name}:#{@player2.deck.cards.count}"
    elsif type == :basic 
      turn.award_spoils(winner)
      p "Turn #{counter}: #{winner.name} won 2 cards"
      p "#{@player1.name}:#{@player1.deck.cards.count} | #{@player2.name}:#{@player2.deck.cards.count}"
    end
  end

  def check_for_winner(counter, turn)
    if turn.player1.has_lost?
      p "*~*~*~* #{@player2.name} has won the game! *~*~*~*"
    elsif turn.player2.has_lost?
      p "*~*~*~* #{@player1.name} has won the game! *~*~*~*"
    elsif counter == 1000 || (turn.player1.has_lost? && turn.player2.has_lost?)
      p "*~*~*~* DRAW *~*~*~*"
    end
  end
end
