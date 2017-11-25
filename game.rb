require 'optparse'

# This will hold the options we parse
@options = {
  dictionary_path: 'data/english.txt',
  debug: false,
  word_size: 4
}

OptionParser.new do |opts|
  opts.banner = 'Usage: game.rb [options]'
  opts.on('--dictionary [FILE_PATH]', 'Use a custom dictionary file instead of the default (default \\\ data/english.txt)') do |v|
    @options[:dictionary_path] = v
  end

  opts.on('-d', '--debug', 'Print additional log messages') do |v|
    @options[:debug] = v
  end

  opts.on('-w', '--word-size [SIZE]', 'Specifies the size of the words in the dictionary (default \\\ 4)') do |v|
    @options[:word_size] = v.to_i
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end.parse!

puts "Options: #{@options}" if @options[:debug]

def load_dictionary
  File.readlines(@options[:dictionary_path]).map(&:strip)
end

def validate_dictionary!(possible_words)
  possible_words.each do |word|
    next if word.chars.uniq.size == @options[:word_size]
    puts "The dictionary file '#{@options[:dictionary_path]}' contains some invalid words like #{word}"
    puts "The words in the dictionary should have #{@options[:word_size]}"\
         ' letters and not contain any repeating letters'
    exit 1
  end
end

def calculate_bulls(word, guess)
  bull_score = 0
  guess.chars.each_with_index do |char, i|
    bull_score += 1 if word[i] == char
  end

  bull_score
end

def calculate_cows(word, guess, bulls)
  cow_score = 0
  selected_chars = word.chars
  guess.chars.each do |char|
    pos_guess = selected_chars.find_index(char)
    next if pos_guess.nil?
    selected_chars.delete_at(pos_guess)
    cow_score += 1
  end

  cow_score - bulls
end

def delete_word?(cows, bulls, new_cow_score, new_bull_score)
  new_total_score = new_cow_score + new_bull_score

  (new_total_score < cows + bulls) ||
  ((bulls.zero? && new_bull_score > 0) || new_bull_score < bulls)
end

def filter_words(possible_words, current_guess = nil, cows = 0, bulls = 0)
  new_words = possible_words.clone
  possible_words.each do |word|
    new_bull_score = calculate_bulls(word, current_guess)
    new_cow_score = calculate_cows(word, current_guess, bulls)
    new_words.delete(word) if delete_word?(cows, bulls, new_cow_score, new_bull_score)
  end

  new_words
end

def guess_word(possible_words)
  possible_words.delete_at(rand(possible_words.size))
end

def ask_score(message)
  print "#{message} "
  loop do
    user_input = gets.strip
    return user_input.to_i if user_input =~ /\A\d\z/
    print "Type a number between 0 and #{@options[:word_size]}: "
  end
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
  turn = 0

  possible_words = load_dictionary

  validate_dictionary!(possible_words)

  loop do
    turn += 1
    possible_words = filter_words(possible_words, current_guess, cows, bulls) if turn > 1
    current_guess = guess_word(possible_words)

    if current_guess.nil?
      puts 'I\'m sorry, but I don\'t have any more guesses'
      break
    end

    puts "Turn: #{turn} - Guess: #{current_guess}"
    puts "Possibilities: #{possible_words.size}" if @options[:debug]

    bulls = ask_bull_score
    break if bulls >= @options[:word_size]
    cows = ask_cow_score
  end

  puts 'Game Over!'
end

play_game
