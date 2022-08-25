class Turn
  attr_reader :player1,
              :player2,
              :spoils_of_war

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    @spoils_of_war = []
  end

  def type
    if player1.deck.rank_of_card_at(0) == player2.deck.rank_of_card_at(0) && player1.deck.rank_of_card_at(2) == player2.deck.rank_of_card_at(2)
      :mutually_assured_destruction
    elsif player1.deck.rank_of_card_at(0) == player2.deck.rank_of_card_at(0)
      :war
    else
      :basic
    end
  end
  
  def winner
    if type == :mutually_assured_destruction
      "There is no winner"
    elsif type == :war
      war_winner
    else  type == :basic
      basic_winner     
    end
  end
  
  def war_winner
    if player1.deck.rank_of_card_at(2) > player2.deck.rank_of_card_at(2)
      @player1
    else
      @player2
    end
  end

  def basic_winner
    if player1.deck.rank_of_card_at(0) > player2.deck.rank_of_card_at(0)
      @player1
    else
      @player2
    end
  end
  
  def pile_cards
    if type == :basic
      basic_spoils
    elsif type == :war
      war_spoils
    else  type == :mutually_assured_destruction
      mad_spoils
    end
  end
  
  def basic_spoils
    @spoils_of_war << player1.deck.cards[0]
    player1.deck.remove_card
    @spoils_of_war << player2.deck.cards[0]
    player2.deck.remove_card
  end
  
  def war_spoils
    @spoils_of_war << player1.deck.cards[0..2]
    3.times { player1.deck.remove_card }
    @spoils_of_war << player2.deck.cards[0..2]
    3.times { player2.deck.remove_card }
    @spoils_of_war.flatten!
  end
  
  def mad_spoils
    player1.deck.cards.shift(3)
    player2.deck.cards.shift(3)
  end

  def award_spoils(winner)
    winner.deck.cards.concat(@spoils_of_war)
  end
end
