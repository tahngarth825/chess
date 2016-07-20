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

    possible_moves.each do |move|
      board_copy = @board.deep_dup
      board_copy.move!(@position,move, @color)
      unless board_copy.in_check?(@color)
        valids << move
      end
    end
    valids
  end
end
