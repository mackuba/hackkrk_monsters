class GameObject
  attr_accessor :x, :y

  def initialize(game, x, y)
    @game = game
    @x = x
    @y = y
  end

  def color
    Curses::COLOR_WHITE
  end

  def char
    raise NotImplementedError
  end

  def alive?
    false
  end
end
