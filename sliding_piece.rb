require_relative "piece"

class SlidingPiece < Piece
  attr_accessor :type, :movelist

  def initialize (starting_pos, color, type)
    @type = type
    super(starting_pos, color)
    set_moves(type)
  end

  def set_moves(type)
    if type == "R "
      @movelist = [:right, :up, :down, :left]
      if @color == :black
        @icon = "\u265C"
      else
        @icon = "\u2656"
      end
    elsif type == "B "
      @movelist = [:upleft, :upright, :downleft, :downright]
      if @color == :black
        @icon = "\u265D"
      else
        @icon = "\u2657"
      end
    elsif type == "Q "
      @movelist = [:upleft, :upright, :downleft,
        :downright, :right, :up, :down, :left]
      if @color == :black
        @icon = "\u265B"
      else
        @icon = "\u2655"
      end
    end
  end

  def moves
    possible_moves = []
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

    while @board.in_bounds?(new_pos)
      if @board[new_pos] == nil
        possible_moves << new_pos
        row += delta_x
        col += delta_y
        new_pos = [row+delta_x, col+delta_y]
      elsif @board[new_pos].color != @color
        possible_moves << [row+delta_x, col + delta_y]
        break
      else
        break
      end
    end
    possible_moves
  end

  def dup
    SlidingPiece.new(@position, @color, @type)
  end
end
