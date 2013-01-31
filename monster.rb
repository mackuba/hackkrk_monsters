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
    try_to_move(Game::DIRECTIONS.sample)
  end
end
