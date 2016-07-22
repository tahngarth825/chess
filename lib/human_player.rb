require_relative "player"

class HumanPlayer < Player

  def initialize(name, color)
    super
  end

  def get_move(display)
    move = []
    valid_moves = []

    while move.length < 2
      input = display.get_input

      if input == :undo
        return nil
      elsif input != nil
        move.push(input)
      end
      if move.length == 1
        display.set_selected(move.first)
        valid_moves = display.board[move.first].valid_moves if display.board[move.first]
        display.set_valid_moves(valid_moves)
      end

      display.render

      puts "#{@name}'s turn (#{@color})"
      if display.board.in_check?(@color)
        puts "#{@name} is in check"
      end
    end
    return move
  end

  def prompt_en_passant(num_pawns)
    verb = "are"
    pawns = "pawns"
    if (num_pawns == 1)
      verb = "is"
      pawns = "pawn"
    end

    response = false

    while (response != "y" && response != "n")
      puts "There #{verb} #{num_pawns} #{pawns} with which #{self.name} can perform en passant."
      puts "Perform en passant? (y/n)"
      response = gets.chomp.downcase
    end

    return response
  end

  def handle_en_passant(pawn_pos)
    down = pawn_pos[0]
    right = pawn_pos[1]

    response = false

    while (response != "y" && response != "n")
      puts "Perform en passant with the pawn #{down} down and #{right} right? (y/n)"
      response = gets.chomp.downcase
    end

    if (response == "y")
      return true
    else
      return false
    end
  end
end
