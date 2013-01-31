require 'creature'

class Monster < Creature
  def char
    "&"
  end

  def color
    Curses::COLOR_RED
  end

  def live
    direction = [:move_up, :move_down, :move_left, :move_right].sample
    send(direction)
  end
end
