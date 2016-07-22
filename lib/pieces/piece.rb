require "colorize"
require "byebug"

class Piece
  attr_accessor :position, :color, :board, :icon, :moved

  def initialize(start_pos, color, moved)
    @color = color
    @position = start_pos
    @board = nil
    @moved = moved
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
    @moved = true
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
      board_copy.move!(@position, move, @color)

      unless board_copy.in_check?(@color)
        if (old_moved == false && castling_moves.values.include?(move))
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
    #King cannot castle out of check.
    #Must check here because king should be able to move out of check normally
    if (board.can_move_to?([0,4], board.other_color(@color)))
      return false
    end

    #King cannot be in check along the way
    #Rook could not have moved; if didn't move, then is rook of same color
    case move
    when [0, 6]
      unless ( board.can_move_to?([0,5], board.other_color(@color)) &&
        !@board[0,7].nil? && @board[0,7].moved == false )
        return true
      end
    when [7, 6]
      unless ( board.can_move_to?([7,5], board.other_color(@color)) &&
        !@board[7,7].nil? && @board[7,7].moved == false )
        return true
      end
    when [0, 2]
      unless ( board.can_move_to?([0,3], board.other_color(@color)) &&
        !@board[0,0].nil? && @board[0,0].moved == false &&
        @board[0,1].nil?)
        return true
      end
    when [7, 2]
      unless ( board.can_move_to?([7,3], board.other_color(@color)) &&
        !@board[7,0].nil? && @board[7,0].moved == false &&
        @board[7,1].nil?)
        return true
      end
    end
  end
end
