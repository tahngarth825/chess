require "colorize"

class Piece
  attr_accessor :position, :color, :board, :icon

  def initialize(start_pos, color)
    @color = color
    @position = start_pos
    @board = nil
  end

  def set_board(board)
    @board = board
  end

  def moves # returns a list of valid moves in children

  end

  def render
    return " #{self.icon.encode("utf-8")}  "
  end

  def update_position(position)
    @position = position
    if (@type == "P " || @type == "Ki" || @type == "R ")
      @moved = true
    end
  end

  def valid_moves
    possible_moves = moves
    valids = []
    castling_moves = {
      :right_black => [0, 6],
      :right_white => [7, 6],
      :left_black => [0, 2],
      :left_white => [7, 2]
    }

    possible_moves.each do |move|
      old_moved = true

      if (@type == "Ki")
        old_moved = @moved
      end

      board_copy = @board.deep_dup
      board_copy.move!(@position,move, @color)

      unless board_copy.in_check?(@color)
        if (old_moved = false && castling_moves.values.include?(move))
          if (check_castling(board_copy, move))
            valids << move
          end
        else
          valids << move
        end
      end
    end
    valids
  end

  def check_castling(board, move)
    #cannot castle if king is in check, so king wasn't in check before
    #king is not in check now, either. So just check in between
    #Would only not work to not move king before checking if
    #the king was blocking, but castle only possible if not in check
    #king cannot be in check along the way
    #could be refactored...

    case move
    when [0, 6]
      if (!board.can_move_to?([0,5], board.other_color(@color)))
        return true
      end
    when [7, 6]
      if (!board.can_move_to?([7,5], board.other_color(@color)))
        return true
      end
    when [0, 2]
      if (!board.can_move_to?([0,3], board.other_color(@color)))
        return true
      end
    when [7, 2]
      if (!board.can_move_to?([7,3], board.other_color(@color)))
        return true
      end
    end

    return false
  end
end
