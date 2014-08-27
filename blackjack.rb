
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
      total -= 10 if total > 21
    end
  end

  return total
end

def process_player(player, dealer, deck)
  player_total = get_card_total(player)

  if player_total < 21
    options = { 'h' => 'Hit', 's' => 'Stay' }
    choice = nil
    choice = options[get_input('Hit or Stay? (h/s)').downcase] until choice != nil
    if choice == options['h']
      deal_card(player, deck)
      clear_screen
      display_cards(dealer)
      display_cards(player)
      process_player(player, dealer, deck)
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
  elsif dealer_total == player_total
    puts 'Game is a draw :|'
    payout(player, 1)
  elsif player_total == 21
    puts 'Blackjack!'
    payout(player, 3)
  elsif dealer_total > 21
    puts 'Dealer busts :)'
    payout(player, 2)
  elsif player_total < 21 && dealer_total < player_total
    puts 'Player wins :) (high card)'
    payout(player, 2)
  elsif dealer_total > player_total
    puts 'Dealer wins :( (high card)'
  end
  puts "\n~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~\n\n"
end

def display_cards(player)
  top_row = ''
  middle_row = ''
  middle2_row = ''
  middle3_row = ''
  bottom_row = ''

  player[:cards].each do |card|
    spacer = ' '
    spacer = '' if card[0].length == 2
    top_row += "/-----\\"
    middle_row += "|#{card[0]} #{spacer} #{card[1]}|"
    middle2_row += "|     |"
    middle3_row += "|#{card[1]} #{spacer} #{card[0]}|"
    bottom_row += "\\-----/"
  end

  if player.has_key?(:name)
    puts player[:name] + "\t\tCash: $#{player[:money]}\t\tBet: $#{player[:bet]}"
  else
    puts 'Dealer'
  end
  puts top_row
  puts middle_row
  puts middle2_row + "\tTotal: #{get_card_total(player)}"
  puts middle3_row
  puts bottom_row
  puts ''
end

def clear_screen
  system('cls')
  system('clear')
  puts "\n~*~*~*~*~*~*~*~*~ Blackjack ~*~*~*~*~*~*~*~*~\n\n"
end

def payout(player, multiplier)
  amount = player[:bet] * multiplier
  player[:money] += amount
  puts "Payout: $#{amount} (#{multiplier}x)"
end

def run_game(player, dealer, deck)
  clear_screen
  player[:money] = get_input("Hello, #{player[:name]}! How much would you like to play with today? (e.g. 500)").to_f until player[:money] > 0
  clear_screen

  while player[:money] > 0 do
    deck = init_deck
    player[:cards] = []
    dealer[:cards] = []
    player[:bet] = 0
    player[:bet] = get_input("How much would you like to bet this hand? [Cash: $#{player[:money]}]").to_f until player[:bet] > 0 && player[:bet] <= player[:money]
    player[:money] -= player[:bet]
    clear_screen

    # Initial Deal
    2.times { deal_card(player, deck); deal_card(dealer, deck) }

    display_cards(dealer)
    display_cards(player)

    process_player(player, dealer, deck)
    process_dealer(dealer, deck)

    clear_screen
    check_for_outcome(player, dealer)
    display_cards(dealer)
    display_cards(player)
  end

  options = { 'y' => true, 'n' => false }
  play_again = nil
  play_again = options[get_input('Play Again? (y/n)').downcase] until play_again != nil
  run_game(player, dealer, deck) if play_again
end

SUITS = ['H', 'D', 'C', 'S']
VALUES = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']

deck = []
player = { name: '', money: 0.0, bet: 0.0, cards: [] }
dealer = { cards: [] }

clear_screen
player[:name] = get_input("What's your name?") until player[:name] != ''

run_game(player, dealer, deck)