require 'creature'

class Player < Creature
  attr_reader :hp

  def initialize(*args)
    super

    @hp = 10
  end

  def char
    "@"
  end

  def color
    Curses::COLOR_GREEN
  end
end
