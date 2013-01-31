require 'creature'

class Player < Creature
  def char
    "@"
  end

  def color
    Curses::COLOR_GREEN
  end

  def max_hp
    10
  end

  def wants_to_attack?(creature)
    true
  end
end
