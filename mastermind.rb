class Code
  COLORS = ["R","G","B","Y","O","P"]

  attr_reader :sequence

  def initialize
    @sequence = COLORS.sample(4)
  end


end

class Mastermind

  def initialize
    @code = Code.new
    @check_report = []
    @player = Player.new
  end

  def check_win(guess = @player.guess)
    @code.sequence.each_with_index do |color, position|
      if color == guess[position]
        @check_report << 1
      elsif @code.sequence.include?(guess[position])
        @check_report << 0
      else
        @check_report << "-"
      end
    end
  end

  def result
    @check_report
  end

  def reset
    @check_report = []
  end

  def print_sequence
    @code.sequence
  end

  def new_guess
    @player.new_guess
  end

  def play
    m = Mastermind.new
    p m.print_sequence
    9.times do
      m.check_win
      return "player won" if m.result == [1,1,1,1]
      p m.result
      m.new_guess
      m.reset

    end
  end


end

class Player

  attr_reader :guess

  def initialize
    @guess = init_guess
  end

  def init_guess
    puts "What is your guess?"
    result = gets.chomp
    guess = []
    result.chars.each do |color|
      guess << color
    end
    guess
  end

  def new_guess
    @guess = init_guess
  end



end

#add functionality so that user can only change incorrect guesses!!!
#check for invalid input IE ZZZZZ ir98327r8932



# #given @check_report
#   if @check_report[i] == 1
#     skip
#   elsif @check_report[i] == 0
#     puts "choose a different pos for this color"
#     guess[i] =
