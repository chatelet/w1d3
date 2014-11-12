class HumanPlayer

  attr_reader :guess, :turns

  def initialize(options=nil)
    @guess = ''
    @secret_word = secret_word
    @answer_word = answer_word
    @length = options
  end


  def guess
    puts "randomly choose a letter between a and z"
    letter = gets.chomp.downcase
  end

  def secret_word
      dictionary = File.readlines("dictionary.txt").map(&:chomp)
      if @length == nil
        secret_word = dictionary.sample
      else
        secret_word =
        dictionary.select{|word| word.length == @length}.sample
      end
      secret_word
  end

  def choose_word_length
    puts "what length do you want?"
    @length = Integer(gets.chomp)
  end

  # def set_both_words
  #   @secret_word = secret_word
  #   @answer_word = answer_word
  # end

  def answer_word
    str = ""
    @secret_word.length.times do
      str += '_'
    end
    str
  end

  def answer_word=(word)
    @answer_word = word
  end

  def check?(guess)
    @secret_word.include?(guess)
  end

  def uncover(guess)
    @secret_word.each_char.with_index do |letter, index|
      if letter == guess
        @answer_word[index] = letter
      end
    end
    @answer_word
  end

  def receive_display(checker)
    checker.answer_word
  end

  def display
    p @answer_word
  end

  def win?
    false
    return true if @secret_word == @answer_word
  end

  def turns_minus_one
    @turns -= 1
  end

end


class ComputerPlayer

  def initialize
    @attempts = []
    @guess = guess
    @answer_word = answer_word
    @secret_word = secret_word
  end



  def guess
    letter = ('a'..'z').to_a.sample
    unless @attempts.include?(letter)
      letter = ('a'..'z').to_a.sample
    end
    letter
  end

  def remember_attempts(guess)
    @attempts << guess
  end

  def max_length
    File.readlines("dictionary.txt").map(&:chomp).max{|a, b| a.length <=> b.length}.length
  end

  def choose_word_length
    puts "what length do you want?"
    @length = (1..max_length).to_a.sample
  end

  def answer_word
    str = ""
    @secret_word.length.times do
      str += '_'
    end
    str
  end
end

class Hangman
  def initialize(guesser, checker)
    @guesser = guesser
    @checker = checker
    @turns = 6
  end


  def winning_message(checker)
    if checker.win?
      puts "#{@guesser} wins"
    else
      puts "#{@checker} wins"
    end
  end

  def play(guesser, checker)
    until (checker.win? || @turns < 1)
      checker.display
      guesser.receive_display(checker)
      puts "you have #{@turns} chances to guess a wrong letter"
      guess = guesser.guess

      if checker.check?(guess)
        checker.answer_word = checker.uncover(guess)
      else
        @turns -= 1
      end

    end
    winning_message(checker)
  end
end
