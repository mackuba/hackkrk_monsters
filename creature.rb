require 'game_object'

class Creature < GameObject
  attr_reader :hp

  def initialize(*args)
    super

    @hp = max_hp
  end

  def max_hp
    10
  end

  def strength
    1
  end

  def char
    "O"
  end

  def try_to_move_to(x, y)
    if @game.can_move_to?(x, y)
      @x, @y = x, y
    elsif (object = @game.object_on_location(x, y)) && object == @game.player
      attack(object)
    end
  end

  def try_to_move(direction)
    try_to_move_to(*location_in_direction(direction))
  end

  def location_in_direction(direction)
    case direction
    when :up then [@x, @y - 1]
    when :down then [@x, @y + 1]
    when :left then [@x - 1, @y]
    when :right then [@x + 1, @y]
    end
  end

  def attack(creature)
    creature.take_damage(strength)
  end

  def take_damage(points)
    @hp -= points

    if @hp <= 0
      @game.cleanup_object(self)
    end
  end

  def alive?
    true
  end

  def speed
    1
  end

  def live
    @life_counter ||= 0
    @life_counter += 1

    if @life_counter >= 1000.0 / speed
      @life_counter = 0
      perform_action
    end
  end

  def perform_action
  end
end
