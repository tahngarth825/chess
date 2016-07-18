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
    @board.display_winner(@cur_player.color)
  end

  def play_turn
    @display.render
    p "#{@cur_player.name}'s turn (#{@cur_player.color})"
    if @board.in_check?(@cur_player.color)
      puts "#{@cur_player.name} is in check"
    end
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

if __FILE__ == $PROGRAM_NAME
  board = Board.new
  player1 = HumanPlayer.new("Richard", :white)
  player2 = HumanPlayer.new("Jordan", :black)
  game = Game.new(board, player1, player2)
  game.play
end

#TO DO LIST
#add logic for castling and "en passe"
#add "undo" for players?
#add pawn promotion
#highlight all possible moves of selected token
