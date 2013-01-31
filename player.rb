require 'creature'
require 'first_aid'

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
