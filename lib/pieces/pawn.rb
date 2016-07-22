require_relative "piece"

class Pawn < Piece
  attr_accessor :type, :movelist, :moved

  def initialize(starting_pos, color, type = "P ")
    @type = type
    super(starting_pos, color)
    set_moves
  end

  def set_moves
    @movelist = []

    if (@color == :black)
      @icon = "\u265F"
      @movelist = [[1,0],[[1,0], [2,0]],[1,1], [1,-1]]
    else
      @icon = "\u2659"
      @movelist = [[-1,0],[[-1,0],[-2,0]],[-1,1], [-1,-1]]
    end
  end

  def moves
    pos_moves = []

    @movelist.each_with_index do |delta, idx|
      if @moved && idx == 1
        next
      end
      pos_moves.concat(get_moves(delta, idx))
    end

    return pos_moves
  end

  def get_moves(delta, index)
    pos_moves = []

    row , col = @position

    case index
    when 0
      new_pos = [row + delta[0], col + delta[1]]
      if @board.in_bounds?(new_pos)
        if @board[new_pos] == nil
          pos_moves.push(new_pos)
        end
      end
    when 1
      delta.each do |move_delta|
        new_pos = [row + move_delta[0], col + move_delta[1]]
        unless (@board.in_bounds?(new_pos) &&
          @board[new_pos] == nil)
          return pos_moves
        end
      end
      pos_moves.push([row+delta[1][0], col+delta[1][1]])
    when 2
      new_pos = [row + delta[0], col + delta[1]]
      if (@board.in_bounds?(new_pos) &&
        !@board[new_pos].nil? &&
        @board[new_pos].color != @color)
        pos_moves << new_pos
      end
    when 3
      new_pos = [row + delta[0], col + delta[1]]
      if (@board.in_bounds?(new_pos) &&
        !@board[new_pos].nil? &&
        @board[new_pos].color != @color)
        pos_moves << new_pos
      end
    end

    pos_moves
  end

  def dup
    Pawn.new(@position, @color, @moved)
  end
end
