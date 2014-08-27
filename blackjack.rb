
# 1) Get the players name
# 2) Build a deck of cards
# 3) Shuffle, give player money
# 4) Get bet, and deal
# 5) Calculate the value of the player and dealer cards
# 6) Evaluate values and determine players available actions (Check for win scenario, bust, etc.)
# 7) Dealer hits if value is under 17
# 8) Reevaluate (reperform step 4 - 8)
# 9) Play until user chooses to quit, or money is exhausted (Repeat from step 2 if user chooses to play again)

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
        total += 11
      when 'J', 'Q', 'K'
        total += 10
      else
        total += x.to_i
    end
  end

  # If the player has an ace, we don't want to push them over 21, so we'll subtract 10 to compensate
  player[:cards].each do |card|
    x = card[0]
    if x == 'A'
      if total > 21
        total -= 10
      end
    end
  end

  return total
end

def process_player(player, deck)
  player_total = get_card_total(player)

  if player_total < 21
    options = { 'h' => 'Hit', 's' => 'Stay' }
    choice = nil
    choice = options[get_input('Hit or Stay? (h/s)').downcase] until choice != nil
    if choice == options['h']
      deal_card(player, deck)
      display_cards(player)
      process_player(player, deck)
    end
  end
end

def process_dealer(dealer, deck)
  deal_card(dealer, deck) until get_card_total(dealer) >= 17
end

def check_for_outcome(player, dealer)
  player_total = get_card_total(player)
  dealer_total = get_card_total(dealer)

  if dealer_total == 21 && player_total < 21
    puts 'Dealer has blackjack :('
  elsif player_total > 21
    puts 'Bust :('
  elsif player_total == 21
    puts 'Blackjack!'
  elsif dealer_total > 21
    puts 'Dealer busts :)'
  elsif player_total < 21 && dealer_total < player_total
    puts 'Player wins :) (high card)'
  elsif dealer_total > player_total
    puts 'Dealer wins :( (high card)'
  elsif dealer_total == player_total
    puts 'Game is a draw :|'
end
end

def display_cards(player)
  puts "#{player[:cards].inspect} Total: #{get_card_total(player)}"
end

SUITS = ['H', 'D', 'C', 'S']
VALUES = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']

deck = init_deck
player = { name: '', money: 0.0, bet: 0.0, cards: [] }
dealer = { cards: [] }

#player[:name] = get_input("What's your name?")
#player[:money] = get_input("Hello, #{player[:name]}! How much would you like to play with today? (e.g. 500)").to_f until player[:money] > 0
2.times { deal_card(player, deck); deal_card(dealer, deck) }
game_over = false
while !game_over do
  puts 'Player:'
  display_cards(player)
  puts 'Dealer:'
  display_cards(dealer)
  process_player(player, deck)
  process_dealer(dealer, deck)
  puts 'Player:'
  display_cards(player)
  puts 'Dealer:'
  display_cards(dealer)
  check_for_outcome(player, dealer)
  game_over = true
end
