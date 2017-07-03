class Code
  attr_reader :pegs

  PEGS = {
    "R" => :red,
    "G" => :green,
    "B" => :blue,
    "Y" => :yellow,
    "O" => :orange,
    "P" => :purple
  }



  def initialize(array)
    @pegs = array
  end

  def self.parse(input)
    unless input.chars.all? { |el| PEGS.keys.include?(el.upcase) }
      raise "Invalid Color."
    end
    array = input.upcase.chars
    Code.new(array)
  end

  def self.random
    random = PEGS.keys.sample(4)
    Code.new(random)

  end

  def [](idx)
    @pegs[idx]
  end

  def exact_matches(guess)
    count = 0
    @pegs.each_index do |idx|
      count += 1 if @pegs[idx] == guess[idx]
    end

    count
  end


  def near_matches(guess)
    count = 0

    original_hash = self.count_colors
    guess_hash = guess.count_colors

    original_hash.each do |color, v|
      if guess_hash[color] && v <= guess_hash[color]
        count += v
      elsif guess_hash[color] && v >= guess_hash[color]
        count += guess_hash[color]
      end


    end
    if count - exact_matches(guess) < 0
      return 0
    end
    count - exact_matches(guess)
  end

  def count_colors
    color_hash = Hash.new(0)

    @pegs.each do |color|
      color_hash[color] += 1
    end

    color_hash
  end

  def ==(guess)
    if guess.class == Code
      return self.pegs == guess.pegs
    end
    false
  end


end




class Game
  attr_reader :secret_code

  def initialize(code = nil)
    @secret_code = code ||= Code.random
  end

  def get_guess
    print "Please enter a guess:"
    input = gets.chomp
    if is_valid?(input)
      return Code.parse(input)
    else
      raise
    end
  rescue
    puts "Invalid Input! Try again"
    retry

  end

  def is_valid?(input)

    return false if input.size != 4
    input.upcase!
    input.chars.all? { |el| Code::PEGS.keys.include?(el) }
  end

  def play
    puts "Welcome to Mastermind! Available colors are O P Y B G R"
    puts "Please make sure you only guess available colors and only 4 at a time."
    puts "Have fun!"
    # p secret_code
    10.times do
      guess = get_guess

      if guess == @secret_code
        puts "Congrats! You won!"
        return
      end

      display_matches(guess)
    end
    puts "You ran out of tries! You lost!"
  end

  def display_matches(guess)
    p "You have #{guess.near_matches(@secret_code)} near matches"
    p "You have #{guess.exact_matches(@secret_code)} exact matches"
  end



end

if __FILE__ == $0
  Game.new.play
end
