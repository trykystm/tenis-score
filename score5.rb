module Composite 
  def <<(elm)
    @sub ||= []
    @sub << elm
  end
  
  def each
    yield(self)
    @sub.each{|elm| elm.each{|elm| yield(elm)}} if @sub
  end
end

class OneToTow
  def initialize(contena)
    @tow_for_one = contena
  end
  
  def <<(contena)
    @tow_for_one << contena
  end
  
  def [](key)
    @tow_for_one[key]
  end
  
  def other(key)
    @tow_for_one.reject{|key1, value| key1 == key}.shift[1]
  end
end


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
  include Composite
  
  def initialize
    @left = Digit.new
    @right = Digit.new
    @player = OneToTow.new({:left => :@left, :right => :@right})
    @default_display = lambda{left.to_s + "-" + right.to_s}
  end
  
  def get_point(side)
    @side = side
    @winner = @player[side]
    @loser = @player.other(side)
    increment
    evaluate
  end
  
  def test_display
    [left, right]
  end  
  
  def display
    @display[@mode].call
  end
  
  private
  
  def left
    @left.digit
  end
  
  def right
    @right.digit
  end
  
  def winner
    instance_variable_get(@winner).digit
  end
  
  def loser
    instance_variable_get(@loser).digit
  end
  
  def reset
    @left.reset!
    @right.reset!
  end
    
  def increment
    instance_variable_get(@winner).increment!
  end
  
  def over
    @sub[0].get_point @side if @sub
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
    self << Game.new(self)
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
    @display = {
      :normal => normal,
      :deuce => deuce, 
      :tie_breake => @default_display, 
      :tie_breake_deuce => @default_display}
  end
end


class Game < Element
  def initialize(point)
    super()
    evaluate_set
    display_set
    @mode = :normal
    self << Sets.new
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
    @display = {
      :normal => @default_display,
      :five_all => @default_display}
  end
end


class Sets < Element #Setとするとdebuggerが何故か動かなくなるので、これだけ複数形
  def initialize
    super
    dummy = lambda {}
    @mode = :dummy
    @evaluate = {:dummy => dummy}
    @display = {:dummy => @default_display}
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
    rtn = []
    @score.each{|elm| rtn << elm.display}
    rtn
  end
  
  def test_array
    rtn = []
    @score.each{|elm| rtn << elm.test_display}
    rtn.flatten
  end
end