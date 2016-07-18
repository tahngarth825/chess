require "colorize"
require_relative "cursorable"

class Display
  include Cursorable

  attr_accessor :board, :cursor_pos, :selected,
    :last_move

  def initialize(board)
    @cursor_pos = [0,0]
    @board = board
    @selected = []
    @last_move = nil
  end

  def set_selected(pos)
    @selected = pos
  end

  def undo
    @board.undo
  end

  def render
    system("clear")
    puts "    0   1   2   3   4   5   6   7"
    @board.grid.each_with_index do |row,ridx|
      print "#{ridx} "
      row.each_with_index do |square,cidx|
        bg = :light_cyan
        if (ridx + cidx) % 2 == 0
          bg = :light_white
        end
        if cursor_pos == [ridx, cidx]
          if square == nil
            print "    ".colorize(:background => :magenta)
          else
            print square.render.colorize(:background => :magenta)
          end
        elsif selected == [ridx, cidx]
          if square == nil
            print "    ".colorize(:background => :light_yellow)
          else
            print square.render.colorize(:background => :light_yellow)
          end
        else
          if square == nil
            print "    ".colorize(:color => :black, :background => bg)
          else
            print square.render.colorize(:color => :black, :background => bg)
          end
        end
      end
      print "\n"
    end
    unless @last_move == nil
      puts "last move was from #{@last_move[0]} to #{@last_move[1]}"
    end
    puts "Choose a square with the arrow keys."
    puts "Select a starting and ending position by pressing Enter."
    puts "Press u to undo a move"
  end
end
