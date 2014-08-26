
# 1) Get the players name
# 2) Build a deck of cards
# 3) Shuffle, give player money
# 4) Get bet, and deal
# 5) Calculate the value of the player and dealer cards
# 6) Evaluate values and determine players available actions (Check for win scenario, bust, etc.)
# 7) Dealer hits if value is under 17
# 8) Reevaluate (reperform step 4 - 8)
# 9) Play until user chooses to quit, or money is exhausted (Repeat from step 2 if user chooses to play again)

# TODO: Fix the logic for the "Ace" so players get either += 1 or 11 depending on the conditions

def get_input(msg)
  puts "~> #{msg} :"
  return gets.chomp
end

def shuffle_deck(deck)
  deck.shuffle!
end

def init_deck
  shuffle_deck(VALUES.product(SUITS))
end

def deal_card(player, deck)
  card = deck.sample
  deck.delete(card)
  player[:cards].push(card)
end

def get_card_total(player)
  total = 0
  player[:cards].each do |card|
    x = card[0]
    case x
      when 'A'
        total += 1
      when 'J', 'Q', 'K'
        total += 10
      else
        total += x.to_i
    end
  end
  return total
end

def blackjack?(player)
  (get_card_total(player) == 21)
end

def bust?(player)
  (get_card_total(player) > 21)
end

SUITS = ['H', 'D', 'C', 'S']
VALUES = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']

deck = init_deck
player = { name: '', money: 0.0, cards: [] }
dealer = { cards: [] }

#player[:name] = get_input("What's your name?")
#player[:money] = get_input("Hello, #{player[:name]}! How much would you like to play with today? (e.g. 500)").to_f until player[:money] > 0

2.times { deal_card(player, deck); deal_card(dealer, deck) }
puts "Player: #{player[:cards].inspect} Total: #{get_card_total(player)}"
puts "Dealer: #{dealer[:cards].inspect} Total: #{get_card_total(dealer)}"