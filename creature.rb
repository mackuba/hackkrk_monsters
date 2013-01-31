require 'game_object'

class Creature < GameObject
  def char
    "O"
  end

  def try_to_move_to(x, y)
    @x, @y = x, y if @game.can_move_to?(x, y)
  end

  def move_up
    try_to_move_to(@x, @y - 1)
  end

  def move_down
    try_to_move_to(@x, @y + 1)
  end

  def move_left
    try_to_move_to(@x - 1, @y)
  end

  def move_right
    try_to_move_to(@x + 1, @y)
  end

  def alive?
    true
  end

  def live
  end
end
