require_relative "board"
require_relative "display"
require_relative "human_player"
require_relative "computer_player"

class Game
  attr_accessor :board, :player1, :player2, :cur_player, :display

  def initialize(board, player1, player2)
    @board = board
    @player1 = player1
    @cur_player = player1
    @player2 = player2
    @display = Display.new(board)
    @board.populate
  end

  def play
    until @board.over?
      play_turn
    end
    @display.render
    @board.display_winner(@cur_player.color, other_player.name)
  end

  def other_player
    if (@cur_player == @player1)
      return @player2
    else
      return @player1
    end
  end

  def turn_display
    if (@board.undo_success == true)
      puts "Undo successful!"
      @board.undo_success = false
    end

    puts "#{@cur_player.name}'s turn (#{@cur_player.color})"

    if @board.in_check?(@cur_player.color)
      puts "#{@cur_player.name} is in check"
    end
  end

  def play_turn
    @display.render

    turn_display

    begin
      move = @cur_player.get_move(@display)
      @display.set_selected([])
      if move == nil
        return
      end
      @board.move(move[0], move[1], cur_player.color)
      next_player
      rescue StandardError => e
        puts e.message
        retry
    end
    @display.last_move = move
  end

  def next_player
    if (@cur_player == @player1)
      @cur_player = @player2
    else
      @cur_player = @player1
    end
  end
end

def start_game
  board = Board.new

  puts "What is your name?"
  name1 = gets.chomp

  response = false

  while (!parse_response(response))
    puts "Hi #{name1}! Would you like to play against a computer or human? (c/h)"
    response = gets.chomp

    if (!parse_response(response))
      puts "Invalid input. Please either type 'c' or 'h'"
    end
  end

  name2="Computer"

  player1 = HumanPlayer.new(name1, :white)
  player2 = ""

  if (response == "c")
    player2 = ComputerPlayer.new(name2, :black)
  elsif (response == "h")
    puts "Enter the name of the second player"
    name2 = gets.chomp
    player2 = HumanPlayer.new(name2, :black)
  end

  game = Game.new(board, player1, player2)
  game.play
end

def parse_response(response)
  if (response == "c" || response == "computer")
    return "c"
  elsif (response == "h" || response == "human")
    return "h"
  else
    return false
  end
end

start_game
