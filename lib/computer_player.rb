require_relative "player"

class ComputerPlayer < Player
  def initialize(name, color)
    super
  end

  def best_move(display, moves)
    smart_move = []
    values = {"Q " => 10, "R " => 5, "Kn" => 3, "B " => 3,
      "P " => 1, "Ki" => 0}
    max_value = 0

    moves.each do |move|
      unless (display.board[move[1]] == nil ||
      display.board[move[1]].color == @color)
        cur_piece = display.board[move[1]].type
        if (values[cur_piece] > max_value)
          if smart_move.empty?
            smart_move << move[0] << move[1]
          else
            smart_move[0], smart_move[1] = move[0], move[1]
          end
          max_value = values[cur_piece]
        end
      end
    end
    if (smart_move.empty?)
      return moves.shuffle.first
    end
    smart_move
  end

  def get_move(display)

    all_moves = []
    display.board.grid.each_with_index do |row, ridx|
      row.each_with_index do |square, cidx|
        if (square != nil && square.color == @color)
          unless square.valid_moves.empty?
            start_pos = [ridx, cidx]
            square.valid_moves.each do |end_pos|
              all_moves.push([start_pos, end_pos])
            end
          end
        end
      end
    end
    best_move(display, all_moves)
  end
end
