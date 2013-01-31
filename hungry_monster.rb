require 'monster'

class HungryMonster < Monster
  def perform_action
    direction_to_player = Game::DIRECTIONS.detect do |dir|
      location = location_in_direction(dir)
      object = @game.object_on_location(*location)
      object == @game.player
    end

    direction_to_player ? try_to_move(direction_to_player) : super
  end
end
