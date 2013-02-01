require 'creature'

class Monster < Creature
  TYPES = [
    [1, 25, '&', Curses::COLOR_MAGENTA],
    [2, 50, '$', Curses::COLOR_BLUE],
    [4, 70, '?', Curses::COLOR_CYAN],
    [8, 90, '@', Curses::COLOR_RED]
  ]

  attr_reader :max_hp, :color, :speed, :char, :level

  def initialize(game, x, y, level)
    @level = level
    @max_hp, @speed, @char, @color = TYPES[level - 1]

    super(game, x, y)
  end

  def wants_to_attack?(creature)
    creature == @game.player
  end

  def perform_action
    try_to_move(Game::DIRECTIONS.sample)
  end
end
