class ComputerPlayer

  attr_reader :answer_word, :flag, :secret_word
  def get_turns(hangman)
    @turns = hangman.turns
  end

  def game_start
    File.readlines("dictionary.txt").map(&:chomp).sample
  end

  def decide_secret_word
    secret_word = game_start
  end

  def make_answer_word
    str = ""
    secret_word.length.times do
      str += '_'
    end
    answer_word = str
  end

  def check_answer?(letter)
    if secret_word.include?(letter)
      secret_word.each_char.with_index do |l, index|
        if l == letter
          answer_word[index] = letter
        end
      end
      answer_word
      flag = false
    else
      flag = true
    end
  end


  def notify_guesser(guesser)
    guesser.receive_answer(answer_word)
  end

  def won?
    return true if secret_word == answer_word
    false
  end



end

class HumanPlayer

  attr_reader :answer_word, :letter

  def guess
    puts "randomly choose a letter between a and z"
    letter = gets.chomp.downcase
  end

  def receive_answer(answer_word)
    answer_word = answer_word
  end

  def get_turns(hangman)
    @turns = hangman.turns
  end

  def notify_checker(checker)
    checker.check_answer?(letter)
  end

end


class Hangman

  attr_reader :turns

  def initialize(checker, guesser)
    @checker = checker
    @guesser = guesser
    @turns = 6
  end

  def update_turns
    checker.get_turns(self)
    guesser.get_turns(self)
  end

  def decrease_turns
    @turns -= 1
  end

  def game_start
    checker.game_start
  end

  def decide_secret_word
    checker.decide_secret_word
  end

  def make_answer_word
    checker.make_answer_word
  end

  def notify_guesser
    checker.notify_guesser(guesser)
  end

  def guesser_turn
    guesser.guess
  end

  def notify_checker
    guesser.notify_checker(checker)
  end

  def update_turns
    @turns -= 1 if checker.flag
  end

  def won?
    checker.won?
  end

  private

  attr_reader :guesser, :checker

end

def play_now
  com = ComputerPlayer.new
  human = HumanPlayer.new
  h = Hangman.new(com, human)
  h.game_start
  h.decide_secret_word
  h.make_answer_word
  loop do
    h.notify_guesser
    h.guesser_turn
    h.notify_checker
    h.update_turns
    return "player wins" if h.won?
    return "computer wins" if h.turns == 0
  end
    #checker checks
end
