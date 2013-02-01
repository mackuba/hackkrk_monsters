require 'creature'
require 'first_aid'
require 'psionic_storm'

class Player < Creature
  attr_reader :xp, :level, :mana

  def initialize(*args)
    @xp = 0
    @level = 1
    @mana = max_mana

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

  def max_mana
    @level / 2
  end

  def wants_to_attack?(creature)
    true
  end

  def add_kill(victim)
    super

    @xp += victim.level

    level_up if @xp >= xp_for_next_level
  end

  def cast_spell
    return unless @mana > 0

    @game.cast_storm(@x, @y)
    @mana -= 1
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

  def speed
    0.7
  end

  def perform_action
    @mana = [@mana + 1, max_mana].min
  end
end
