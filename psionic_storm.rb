require 'game_object'

class PsionicStorm < GameObject
  def texture
    ["~" * 5] * 5
  end

  def color
    Curses::COLOR_CYAN
  end

  def large_object?
    false
  end

  def alive?
    true
  end

  def live
    @life_counter ||= 0
    @life_counter += 1

    if @life_counter >= 0.5 / @game.sleep_time
      @game.cleanup_object(self)
    end
  end
end
