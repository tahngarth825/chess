require_relative "display"
require_relative "pieces/sliding_piece"
require_relative "pieces/step_piece"
require_relative "pieces/pawn"

class Board
  attr_accessor :grid, :last_board

  def initialize(grid = Array.new(8) {Array.new(8) {nil}}, last_board = nil)
    @grid = grid
    @last_board = last_board
  end

  def [] (pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @grid[row][col] = value
  end

  def populate
    set_rooks
    set_knights
    set_bishops
    set_kings
    set_queens
    set_pawns

    @grid.each_with_index do |row, ridx|
      row.each do |square, cidx|
        square.set_board(self) unless square == nil
      end
    end
  end

  def set_rooks
    self[[0,0]] = SlidingPiece.new([0,0], :black, "R ")
    self[[0,7]] = SlidingPiece.new([0,7], :black, "R ")
    self[[7,0]] = SlidingPiece.new([7,0], :white, "R ")
    self[[7,7]] = SlidingPiece.new([7,7], :white, "R ")
  end

  def set_knights
    self[[0,1]] = StepPiece.new([0,1], :black, "Kn")
    self[[0,6]] = StepPiece.new([0,6], :black, "Kn")
    self[[7,1]] = StepPiece.new([7,1], :white, "Kn")
    self[[7,6]] = StepPiece.new([7,6], :white, "Kn")
  end

  def set_bishops
    self[[0,2]] = SlidingPiece.new([0,2], :black, "B ")
    self[[0,5]] = SlidingPiece.new([0,5], :black, "B ")
    self[[7,2]] = SlidingPiece.new([7,2], :white, "B ")
    self[[7,5]] = SlidingPiece.new([7,5], :white, "B ")
  end

  def set_kings
    self[[0,4]] = StepPiece.new([0,4], :black, "Ki")
    self[[7,4]] = StepPiece.new([7,4], :white, "Ki")
  end

  def set_queens
    self[[0,3]] = SlidingPiece.new([0,3], :black, "Q ")
    self[[7,3]] = SlidingPiece.new([7,3], :white, "Q ")
  end

  def set_pawns
    @grid[1].each_with_index do |square, index|
      @grid[1][index] = Pawn.new([1,index], :black)
    end

    @grid[6].each_with_index do |square, index|
      @grid[6][index] = Pawn.new([6,index], :white)
    end
  end

  def in_bounds?(pos)
    row, col = pos

    return false unless row.between?(0,7) && col.between?(0,7)
    return true
  end

  def move(start_pos, end_pos, cur_player)
    if self[start_pos] == nil
      raise StandardError.new("no piece in starting position")
    end
    unless self[start_pos].color == cur_player
      raise StandardError.new("cannot move enemy piece")
    end
    piece = self[start_pos]
    if !piece.valid_moves.include?(end_pos)
      raise StandardError.new("piece cannot move to end location")
    end

    @last_board = deep_dup

    self[start_pos] = nil
    self[end_pos] = piece
    piece.update_position(end_pos)
  end

  def move!(start_pos, end_pos, cur_player)
    if self[start_pos] == nil
      raise StandardError.new("no piece in starting position")
    end
    unless self[start_pos].color == cur_player
      raise StandardError.new("cannot move enemy piece")
    end
    piece = self[start_pos]
    if !piece.moves.include?(end_pos)
      raise StandardError.new("piece cannot move to end location")
    end

    self[start_pos] = nil
    self[end_pos] = piece
    piece.update_position(end_pos)
  end

  def other_color(color)
    if color == :black
      return :white
    else
      return :black
    end
  end

  def in_check?(color)
    king_position = find_position("Ki", color)
    if can_move_to?(king_position, other_color(color))
      return true
    end
    false
  end

  def find_position(type, color)
    @grid.each_with_index do |row, ridx|
      row.each_with_index do |square, cidx|
        if square != nil && square.type == type && square.color == color
          return [ridx, cidx]
        end
      end
    end
    nil
  end

  def can_move_to?(position, color)
    @grid.each do |row|
      row.each do |square|
        if (square != nil && square.color == color &&
          square.moves.include?(position))
          return true
        end
      end
    end
    return false
  end

  def checkmate?(color)
    if in_check?(color)
      @grid.each do |row|
        row.each do |square|
          if square == nil || square.color != color
            next
          else
            return false unless square.valid_moves.empty?
          end
        end
      end
      return true
    end
    return false
  end

  def deep_dup
    new_grid = []
    @grid.each do |row|
      add = []
      row.each do |square|
        if square == nil
          add.push(nil)
        else
          add.push(square.dup)
        end
      end
      new_grid.push(add)
    end
    new_board = Board.new(new_grid, @last_board)
    new_grid.each_with_index do |row, ridx|
      row.each do |square, cidx|
        square.set_board(new_board) unless square == nil
      end
    end
    new_board
  end

  def over?
    if (checkmate?(:black) || checkmate?(:white) ||
      stalemate?(:black) || stalemate?(:white))
      return true
    end
    return false
  end

  def display_winner(color)
    if (checkmate?(color))
      puts  "Checkmate! #{other_color(color)} wins!"
    elsif (stalemate?(:black) || stalemate?(:white))
      puts "Stalemate; nobody wins :/"
    end
  end

  def stalemate?(color)
    @grid.each do |row|
      row.each do |square|
        if square == nil || square.color != color
          next
        else
          return false unless square.valid_moves.empty?
        end
      end
    end
    return true
  end

  def undo
    @grid = last_board.last_board.grid
    puts "Undo successful!"
  end
end

if __FILE__ == $PROGRAM_NAME
  board = Board.new
  display = Display.new(board)
  board.populate
  board_copy = board.deep_dup
  board.move([0,0], [1,0], :black)
  display.render


  display2 = Display.new(board_copy)
  display2.render

end
