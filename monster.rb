require 'creature'

class Monster < Creature
  def char
    "&"
  end

  def speed
    30
  end

  def max_hp
    1
  end

  def color
    Curses::COLOR_RED
  end

  def perform_action
    direction = [:move_up, :move_down, :move_left, :move_right].sample
    send(direction)
  end
end
