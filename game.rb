DICTIONARY_PATH = 'data/english.txt'.freeze
WORD_SIZE = 4
DEBUG = true

def load_dictionary
  File.readlines(DICTIONARY_PATH).map(&:strip)
end

def calculate_bulls(word, guess)
  bull_score = 0
  guess.chars.each_with_index do |char, i|
    bull_score += 1 if word[i] == char
  end

  bull_score
end

def calculate_cows(word, guess)
  cow_score = 0
  selected_chars = word.chars
  guess.chars.each do |char|
    pos_guess = selected_chars.find_index(char)
    next if pos_guess.nil?
    selected_chars.delete_at(pos_guess)
    cow_score += 1
  end

  cow_score
end

def filter_words(possible_words, current_guess = nil, cows = 0, bulls = 0)
  new_words = filter_by_cow_score(possible_words, current_guess, cows)
  new_words = filter_by_bull_score(new_words, current_guess, bulls)
  new_words
end

def filter_by_cow_score(possible_words, current_guess, cows)
  new_words = possible_words.clone
  possible_words.each do |word|
    new_cow_score = calculate_cows(word, current_guess)
    if (cows.zero? && new_cow_score > 0) || new_cow_score < cows
      new_words.delete(word)
    end
  end

  new_words
end

def filter_by_bull_score(possible_words, current_guess, bulls)
  new_words = possible_words.clone
  possible_words.each do |word|
    new_bull_score = calculate_bulls(word, current_guess)
    if (bulls.zero? && new_bull_score > 0) || new_bull_score < bulls
      new_words.delete(word)
    end
  end

  new_words
end

def guess_word(possible_words)
  possible_words.delete_at(rand(possible_words.size))
end

def ask_score(message)
  puts message
  gets.to_i
end

def ask_bull_score
  ask_score('Please, enter the number of bulls:')
end

def ask_cow_score
  ask_score('Please, enter the number of cows:')
end

def play_game
  current_guess = nil
  bulls = 0
  cows = 0
  attempt = 0

  possible_words = load_dictionary

  loop do
    attempt += 1
    possible_words = filter_words(possible_words, current_guess, cows, bulls) unless current_guess.nil?
    current_guess = guess_word(possible_words)

    if current_guess.nil?
      puts 'I\'m sorry, but I don\'t have any more guesses'
      break
    end

    puts "Attempt: #{attempt} - Guess: #{current_guess}"
    puts "Possibilities: #{possible_words.size}" if DEBUG

    cows = ask_cow_score
    bulls = cows.zero? ? 0 : ask_bull_score

    break if bulls >= WORD_SIZE
  end

  puts 'Game Over!'
end

play_game
