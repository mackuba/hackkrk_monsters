require 'first_aid'
require 'hungry_monster'
require 'player'
require 'wall'

class Game
  DIRECTIONS = [:up, :down, :left, :right]

  MONSTER_SPAWN_RATE = 0.5
  FIRST_AID_DROP_RATE = 0.1

  attr_reader :objects, :width, :height, :exit_message, :player

  def initialize(width, height)
    @width = width
    @height = height
    @objects = []
    @exit_message = "Bye!"
    @log = File.open("log", "a")

    place_walls
    place_player
    place_monsters
  end

  def log(line = "")
    @log.puts(line)
  end

  def place_walls
    fields = @width * @height
    walls_count = rand(fields/6 .. fields/4)
    walls_count.times { place_wall }
  end

  def place_wall
    wall = Wall.new(self, *random_empty_location)
    @objects << wall
  end

  def place_monsters
    fields = @width * @height
    monsters_count = fields/30
    monsters_count.times { place_monster }
  end

  def place_monster
    monster = HungryMonster.new(self, *random_empty_location_not_near_player, monster_level)
    @objects << monster
  end

  def place_player
    @player = Player.new(self, *random_empty_location)
    @objects << @player
  end

  def place_first_aid
    first_aid = FirstAid.new(self, *random_empty_location_not_near_player)
    @objects << first_aid
  end

  def cast_storm(x, y)
    dead = @objects.select { |o| (o.x - x).abs <= 2 && (o.y - y).abs <= 2 && o.is_a?(Creature) && o != @player }
    dead.each do |o|
      @player.add_kill(o)
      cleanup_object(o)
    end

    storm = PsionicStorm.new(self, x - 2, y - 2)
    @objects << storm
  end

  def monster_level
    points = rand(1000) * @player.level

    case
      when points < 800 then 1
      when points < 2000 then 2
      when points < 3600 then 3
      else 4
    end
  end

  def random_location(&block)
    begin
      x, y = rand(@width), rand(@height)
    end until block.call(x, y)

    [x, y]
  end

  def random_empty_location
    random_location { |x, y| location_empty?(x, y) }
  end

  def random_empty_location_not_near_player
    random_location { |x, y| location_empty?(x, y) && location_not_near_player?(x, y) }
  end

  def wait?
    false
  end

  def sleep_time
    0.01
  end

  def cleanup_object(object)
    @objects.delete(object)

    if object == @player
      quit "You've died in a battle #{quit_message}!"
    end
  end

  def monsters
    objects.select { |o| o.is_a?(Monster) }
  end

  def textbox_content
    [
      "jkli=move, s=magic, q=quit, space=pause",
      "HP: #{@player.hp}/#{@player.max_hp}",
      "Mana: #{@player.mana}/#{@player.max_mana}",
      "XP: #{@player.xp}/#{@player.xp_for_next_level}",
      "Lvl: #{@player.level}",
      "Mon: #{monsters.count}"
    ].join(" | ")
  end

  def input_map
    {
      'q' => :quit,
      'j' => :move_left,
      'k' => :move_down,
      'l' => :move_right,
      'i' => :move_up,
      ' ' => :pause,
      's' => :cast_spell
      # Curses::KEY_LEFT => :move_left
      # 27 => :handle_arrow
    }
  end

  DIRECTIONS.each do |dir|
    define_method("move_#{dir}") do
      @player.try_to_move(dir)
    end
  end

  # def handle_arrow
  #   code = [Curses::getch, Curses::getch, Curses::getch, Curses::getch, Curses::getch]
  # 
  #   command = case code[1]
  #     when 'A' then :move_up
  #     when 'B' then :move_down
  #     when 'C' then :move_right
  #     when 'D' then :move_left
  #   end
  # 
  #   @player.send(command) if command
  # end

  def tick
    return if @pause

    @objects.each { |o| o.live if o.alive? }

    random_event(MONSTER_SPAWN_RATE) { place_monster }
    random_event(FIRST_AID_DROP_RATE) { place_first_aid }
  end

  def pause
    @pause = !@pause
  end

  def cast_spell
    @player.cast_spell
  end

  def random_event(rate, &block)
    block.call if rand < rate * sleep_time
  end

  def quit(message = nil)
    @exit_message = message || "You've retired #{quit_message}."

    Kernel.exit
  end

  def quit_message
    case @player.kill_count
      when 0 then "after killing no monsters at all - what a shame"
      when 1 then "after killing just one monster"
      else "after killing #{@player.kill_count} monsters"
    end
  end

  def location_on_map?(x, y)
    (0...@width) === x && (0...@height) === y
  end

  def object_on_location(x, y)
    @objects.detect { |o| o.x == x && o.y == y }
  end

  def location_empty?(x, y)
    @objects.none? { |o| o.x == x && o.y == y && o.large_object? }
  end

  def location_not_near_player?(x, y)
    (@player.x - x).abs + (@player.y - y).abs >= 5
  end

  def can_move_to?(x, y)
    location_on_map?(x, y) && location_empty?(x, y)
  end
end
