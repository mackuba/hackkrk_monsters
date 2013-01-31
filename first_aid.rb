require 'game_object'

class FirstAid < GameObject
  def color
    Curses::COLOR_YELLOW
  end

  def large_object?
    false
  end

  def char
    "+"
  end

  def size
    5
  end
end
