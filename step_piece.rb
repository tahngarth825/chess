require_relative "piece"
require "byebug"

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
        :downright, :right, :up, :down, :left]
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
    end
    movelist.each do |direction|
      possible_moves.concat(get_moves(direction))
    end
    return possible_moves
  end

  def get_moves(direction)
    deltas = {:right => [0,1], :left => [0,-1],
      :up => [-1, 0], :down => [1,0], :upleft => [-1,-1],
      :upright => [-1,1], :downleft => [1,-1],
      :downright => [1,1]}

    row, col = @position
    delta_x, delta_y = deltas[direction]
    possible_moves = []
    new_pos = [row+delta_x, col+delta_y]

    if @board.in_bounds?(new_pos)
      if @board[new_pos] == nil || @board[new_pos].color != @color
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
