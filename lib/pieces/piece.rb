require "colorize"
require "byebug"

class Piece
  attr_accessor :position, :color, :board, :icon, :moved

  CASTLING_MOVES = [
    [0, 6],
    [7, 6],
    [0, 2],
    [7, 2]
  ]

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

    possible_moves.each do |move|
      old_moved = true

      if (@type == "Ki")
        old_moved = @moved
        old_pos = @position
      end

      board_copy = @board.deep_dup
      board_copy.move!(@position, move, @color)

      #You cannot move into check
      unless board_copy.in_check?(@color)
        #only checks case where King didn't move and it's king moving there
        if (old_moved == false && CASTLING_MOVES.include?(move))
          if (check_castling(board_copy, move, old_pos))
            valids << move
          end
        else
          valids << move
        end
      end
    end
    valids
  end

  def check_castling(board, move, old_pos)
    #King cannot castle out of check.
    #Must check here because king should be able to move out of check normally
    if (board.can_move_to?(old_pos, board.other_color(@color)))
      return false
    end

    #King cannot be in check along the way
    #Rook could not have moved; if didn't move, then is rook of same color
    case move
    when CASTLING_MOVES[0]
      if ( !board.can_move_to?([0,5], board.other_color(@color)) &&
        !@board[[0,7]].nil? && @board[[0,7]].moved == false )
        return true
      end
    when CASTLING_MOVES[1]
      if ( !board.can_move_to?([7,5], board.other_color(@color)) &&
        !@board[[7,7]].nil? && @board[[7,7]].moved == false )
        return true
      end
    when CASTLING_MOVES[2]
      if ( !board.can_move_to?([0,3], board.other_color(@color)) &&
        !@board[[0,0]].nil? && @board[[0,0]].moved == false &&
        @board[[0,1]].nil?)
        return true
      end
    when CASTLING_MOVES[3]
      if ( !board.can_move_to?([7,3], board.other_color(@color)) &&
        !@board[[7,0]].nil? && @board[[7,0]].moved == false &&
        @board[[7,1]].nil?)
        return true
      end
    end
  end
end
