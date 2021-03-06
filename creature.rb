require 'game_object'

class Creature < GameObject
  attr_reader :hp, :kill_count

  def initialize(*args)
    super

    @hp = max_hp
    @kill_count = 0
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

  def wants_to_attack?(creature)
    false
  end

  def add_kill(victim)
    @kill_count += 1
  end

  def try_to_move_to(x, y)
    if @game.can_move_to?(x, y)
      move_to(x, y)
    elsif object = @game.object_on_location(x, y)
      if object.alive? && wants_to_attack?(object)
        attack(object)
      end
    end
  end

  def move_to(x, y)
    @x, @y = x, y
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
    creature.take_damage_from(self, strength)
  end

  def take_damage_from(attacker, points)
    @hp -= points

    if @hp <= 0
      @game.cleanup_object(self)
      attacker.add_kill(self)
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
