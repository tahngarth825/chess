require_relative "piece"

class StepPiece < Piece
  attr_accessor :type, :movelist

  def initialize (starting_pos, color, type)
    @type = type
    super(starting_pos, color)
    set_moves(type)
  end

  def set_moves(type)
    if type == "Ki"
      @movelist = [:upleft, :upright, :downleft,
        :downright, :right, :up, :down, :left,
        :castle_left, :castle_right]
      if @color == :black
        @icon = "\u265A"
      else
        @icon = "\u2654"
      end
    elsif type == "Kn"
      @movelist = [:special]
      if @color == :black
        @icon = "\u265E"
      else
        @icon = "\u2658"
      end
    end
  end

  def moves
    possible_moves = []
    if type == "Kn"
      return get_knight_moves
    else
      movelist.each do |direction|
        possible_moves.concat(get_moves(direction))
      end

      #we don't check castling moves because only the rook could put the king in
      #check, and it could have done that without castling. See #valid_moves in
      #piece for castling logic
      return possible_moves
    end
  end

  #Is just king's moves. Could be refactored. should be singular.
  #Handles castle logic only in that nothing is in the king's way
  #See #valid_moves in piece.rb for more castling logic
  def get_moves(direction)
    deltas = {:right => [0,1], :left => [0,-1],
      :up => [-1, 0], :down => [1,0], :upleft => [-1,-1],
      :upright => [-1,1], :downleft => [1,-1], :downright => [1,1],
      :castle_left => [0, -2], :castle_right => [0, 2]}

    row, col = @position
    delta_x, delta_y = deltas[direction]
    possible_moves = []
    new_pos = [row+delta_x, col+delta_y]

    if (direction == :castle_left || direction == :castle_right)
      halfway = [row+(delta_x/2), col+(delta_y/2)]
      if (@board.in_bounds?(new_pos) && @board[new_pos] == nil &&
        @board[halfway] == nil)
        possible_moves.push(new_pos)
      end
    elsif @board.in_bounds?(new_pos)
      if (@board[new_pos] == nil || @board[new_pos].color != @color)

        possible_moves.push(new_pos)
      end
    end

    possible_moves
  end

  def get_knight_moves
    moves = [
    [-2, -1],
    [-2,  1],
    [-1, -2],
    [-1,  2],
    [ 1, -2],
    [ 1,  2],
    [ 2, -1],
    [ 2,  1]]

    valid_moves = []

    cur_x, cur_y = @position
    moves.each do |(dx, dy)|
      new_pos = [cur_x + dx, cur_y + dy]

      if new_pos.all? { |coord| coord.between?(0, 7) }
        if (@board[new_pos] == nil || @board[new_pos].color != @color)
          valid_moves << new_pos
        end
      end
    end
    valid_moves
  end

  def dup
    StepPiece.new(@position, @color, @type)
  end
end
