require 'creature'
require 'first_aid'

class Player < Creature
  attr_reader :xp, :level

  def initialize(*args)
    @xp = 0
    @level = 1

    super
  end

  def xp_for_next_level
    (10 * @level**1.25).to_i
  end

  def char
    "@"
  end

  def color
    Curses::COLOR_GREEN
  end

  def max_hp
    8 + @level * 2
  end

  def wants_to_attack?(creature)
    true
  end

  def add_kill(victim)
    super

    @xp += victim.level

    level_up if @xp >= xp_for_next_level
  end

  def level_up
    @level += 1
  end

  def move_to(x, y)
    if object = @game.object_on_location(x, y)
      consume_object(object)
      @game.cleanup_object(object)
    end

    super
  end

  def consume_object(object)
    case object
    when FirstAid
      @hp = [@hp + object.size, max_hp].min
    end
  end
end
