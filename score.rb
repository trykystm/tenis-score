class Digit
  attr_reader :digit
  
  def initialize
    reset! 
  end
  
  def increment!
    @digit += 1
  end
  
  def reset!
    @digit = 0
  end
  
  def deuce_again!
    @digit = 3
  end
end


class Element
  def initialize
    @left = Digit.new
    @right = Digit.new
  end
  
  def get_point(side)
    @side = side
    winner_set
    increment
    evaluate
  end
  
  def display
    rtn = []
    rtn << @display[@mode].call
    rtn << @super.display if @super
    rtn.flatten
  end
  
  def test_display
    rtn = []
    rtn << left
    rtn << right 
    @super.test_display.each{|aug|rtn << aug} if @super
    rtn
  end   
  
  private
  
  def left
    @left.digit
  end
  
  def right
    @right.digit
  end
  
  def winner
    @winner.digit
  end
  
  def loser
    @loser.digit
  end
  
  def reset
    @left.reset!
    @right.reset!
  end
  
  def winner_set
    case @side
      when :left
      @winner = @left
      @loser = @right
      when :right
      @winner = @right
      @loser = @left
    end
  end
  
  def increment
    @winner.increment!
  end
  
  def over
    @super.get_point @side
    reset
  end
  
  def evaluate
    @evaluate[@mode].call
  end
end  


class Point < Element
  attr_writer :mode
  
  def initialize  
    super()
    evaluate_set
    display_set
    @super = Game.new self
    @mode = :normal
  end
  
  private
  
  def deuce_again
    @left.deuce_again!
    @right.deuce_again!
  end
  
  def evaluate_set
    normal = lambda do
      if winner == 4
        @mode = :normal
        over
      elsif left == 3 && right ==3
        @mode = :deuce
      end
    end
    deuce = lambda do
      if winner == 5
        @mode = :normal
        over
      elsif left == 4 && right ==4
        deuce_again
      end
    end
    tie_breake = lambda do
      if winner == 7
        @mode = :normal
        over
      elsif left == 6 && right == 6
        @mode = :tie_breake_deuce
      end
    end
    tie_breake_deuce = lambda do
      if winner - loser == 2
        @mode = :normal
        over
      end
    end
    @evaluate = {
      :normal => normal,
      :deuce => deuce, 
      :tie_breake => tie_breake, 
      :tie_breake_deuce => tie_breake_deuce}
  end
  
  def display_set
    normal = lambda do
      num = ["0", "15", "30", "40"]
      num[left] + "-" + num[right]
    end
    deuce = lambda do
      if left == 3 && right == 3
        "Deuce"
      elsif left ==4
        "A- "
      else
        " -A"
      end
    end
    tie_breake = lambda do
      left.to_s + "-" + right.to_s
    end
    tie_breake_deuce = lambda do
      left.to_s + "-" + right.to_s
    end
    @display = {
      :normal => normal,
      :deuce => deuce, 
      :tie_breake => tie_breake, 
      :tie_breake_deuce => tie_breake_deuce}
  end
end


class Game < Element
  
  def initialize(point)
    super()
    evaluate_set
    display_set
    @mode = :normal
    @super = Sets.new
    @point = point
  end
  
  private
  
  def evaluate_set
    normal = lambda do
      if winner == 6
        over
      elsif left == 5 && right == 5
        @mode = :five_all
      end
    end
    five_all = lambda do
      if winner == 7
        @mode = :normal
        over
      elsif left == 6 && right ==6
        @point.mode = :tie_breake
      end
    end   
    @evaluate = {
      :normal => normal,
      :five_all => five_all}
  end
  
  def display_set
    normal = lambda do
      left.to_s + "-" + right.to_s
    end
    five_all = lambda do
      left.to_s + "-" + right.to_s
    end   
    @display = {
      :normal => normal,
      :five_all => five_all}
  end
end


class Sets < Element #Setとするとdebuggerが何故か動かなくなるので、これだけ複数形
  def initialize
    super
    @super = nil
    dummy = lambda {}
    @mode = :dummy
    @evaluate = {:dummy => dummy}
    @display = {:dummy => lambda{left.to_s + "-" + right.to_s}}
  end
end


class Score  
  def initialize
    @score = Point.new
  end
  
  def get_point(side)
    @score.get_point side
  end
  
  def display
    @score.display
  end
  
  def test_array
    @score.test_display
  end
end
