#きっかけはpointの１点追加。
#直後point中left、rightの状態を観察しmode変更とgameの１点追加。
#同じくgame中のleft、rightの状態を観察しmode変更とsetの１点追加。
#modeとは上のカテゴリに1点追加する条件、表示の仕方

class Table
  def initialize(*row)
    @table = row #[[a, b, c], [d, e, f], [g, h, i]]
  end
  
  def << row
    @table << row #<<[j, k, l] => [[a, b, c], [d, e, f], [g, h, i],[j, k, l]]
  end
  
  def get(pointer)
    current = pointer.current
    @table[current[0]][current[1]]
  end
  
  def inspect
    p @table
  end
end  

class Player
  attr_accessor :winner, :loser
  def initialize winner_player
    @winner = winner_player
    @loser = (@winner == :left) ? :right : :left
  end
  
  def other
    @loser
  end
  
  def other_level!
    
  end
  
  def upper!
    case @current_score
      when :points
      @current_score = :games
      when :games
      @current_score = :sets
    end
    
  end
  
  def lower!
    @pointer[0] += 1
  end
  
  def left!
    @pointer[1] -= 1
  end
  
  def right!
    @pointer[1] +=1
  end 
end

class Digit
  attr_accessor :digit
  def initialize
    reset! 
  end
  
  def increment!
    @digit += 1
  end
  
  def reset!
    @digit = 0
  end
  
  def inspect
    @digit
  end
end

class Score
  attr_accessor :left, :right, :mode, :over
  def initialize mode
    @left = Digit.new
    @right = Digit.new
    @mode = mode
    @over = false
  end
  
  def increment player
    case player
      when :left
      @left.increment
      when :right
      @right.increment
    end
  end
  
  def evaluate player
    @mode.evaluate player
  end
  
  def over?
    @over
  end
  
  def display
    @mode.display
  end
  
  def mode_change mode
    @mode = mode
  end
end

class Point
  NORMAL = Object.new
  DEUCE = Object.new
  class << NORMAL
    def evaluate main
      winner_point = main.points.send(main.player.winner)
      if winner_point.digit == 4
        winner_point.reset!
        winner_point.reset!
        winner_point.over = true
      elsif winner_point.digit == 3 && @points.send(player.other).digit == 3
        mode = Point::DEUCE
      end
    end
    
    def display
      
    end
  end  
  
  class << DEUCE
    def evaluate
      
    end
    
    def display
      
    end    
  end
  #  
  #  def Normal.display
  #    
  #  end
  #  
  #  Deuce = Object.new
  #  def Deuce.evaluate
  #    
  #  end
  #  
  #  def Deuce.display
  #    
  #  end
  #  
  #  TieBrake = Object.new
  #  def TieBrake.valuate
  #    
  #  end
  #  
  #  def TieBrake.display
  #    
  #  end
  #
  #  def initialize 
  #    super Normal
  #  end
end

class Game
  NORMAL = lambda do
    
  end
end

class Main
  attr_reader :sets, :games, :points, :player
  def initialize
    @sets = Score.new nil
    @games = Score.new Game::NORMAL
    @points = Score.new Point::NORMAL
  end
  
  def add_score winner
    @player = Player.new winner
    increment_points @player
    @points.evaluate self
    if @points.over?
      increment_games @player
      @games.evaluate self
      if @games.over?
        increment_sets @player
      end
    end
    display
  end
  
  def inspect
    p @points
  end
  
  def get
    inspect
  end
  
  private
  
  def increment_points player
    @points.send(player.winner).increment!
  end
  
  #  def increment(pointer)
  #    digit = @score.get(pointer)
  #    digit.increment!
  #    if digit.max?
  #      @score.get(pointer).reset!
  #      @score.get(pointer.other_side).reset!
  #      increment(pointer.upper!)
  #    end
  #    if digit.get = 3 && @score.get(pointer.other_side).get = 3
  #      digit.max = 5
  #    end 
  #  end
  
  def calculate
    
  end
  
end

if $0 ==__FILE__
  #Score.increment(:right, "0-0, 3-2, 15-30")
  main = Main.new
  p main.add_score(:left)
  #  100.times do
  #    score.get_point(0)
  #    p score
  #    score.get_point(1)
  #    p score
  #    score.get_point(0)
  #    p score
  #    score.get_point(1)
  #    p score
  #    score.get_point(1)
  #    p score
  #  end
end




count(0,"6-6, -A")
