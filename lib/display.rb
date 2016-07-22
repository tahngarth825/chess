require "colorize"
require_relative "cursorable"

class Display
  include Cursorable

  attr_accessor :board, :cursor_pos, :selected,
    :last_move, :valid_moves

  def initialize(board)
    @cursor_pos = [0,0]
    @board = board
    @selected = []
    @last_move = nil
    @valid_moves = []
  end

  def set_selected(pos)
    @selected = pos
  end

  def set_valid_moves(valid_moves)
    @valid_moves = valid_moves
  end

  def undo
    @board.undo
  end

  def render
    system("clear")
    puts "    0   1   2   3   4   5   6   7"
    color = :black

    @board.grid.each_with_index do |row,ridx|
      print "#{ridx} "
      row.each_with_index do |square,cidx|
        bg = :light_cyan
        if (ridx + cidx) % 2 == 0
          bg = :light_white
        end

        if cursor_pos == [ridx, cidx]
          bg = :magenta
        elsif @selected == [ridx, cidx]
          bg = :light_yellow
        elsif @valid_moves.include?([ridx, cidx])
          bg = :green
        end

        if square == nil
          print "    ".colorize(:color => color, :background => bg)
        else
          print square.render.colorize(:color => color, :background => bg)
        end
      end
      print "\n"
    end
    unless @last_move == nil
      puts "Last move was from #{parse_move(@last_move[0])} to #{parse_move(@last_move[1])}"
    end
    puts "Choose a square with the arrow keys."
    puts "Select a starting and ending position by pressing Enter."
    puts "Press u to undo a move"
    puts "Castle by moving the king two spaces in the appropriate direction"
  end

  def parse_move(move)
    bottom = move[0]
    right = move[1]
    return "#{bottom} down and #{right} right"
  end
end
