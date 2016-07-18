require_relative "player"

class HumanPlayer < Player

  def initialize(name, color)
    super
  end

  def get_move(display)
    move = []
    while move.length < 2
      input = display.get_input
      display.render
      p "#{@name}'s turn (#{@color})"
      if display.board.in_check?(@color)
        puts "#{@name} is in check"
      end

      if input == :undo
        return nil
      elsif input != nil
        move.push(input)
      end
      if move.length == 1
        display.set_selected(move.first)
      end
    end
    return move
  end
end
