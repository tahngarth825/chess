##Chess
This is a version of Chess playable in the terminal that was initially developed in conjunction with my partner [Jordan Minatogawa][partner]. Features that we implemented together include a smart AI that prioritizes higher-value targets and an undo function.

Features that I updated include starting the game with a choice of 1-player or 2-player, refactoring code, improving user experience by parsing outputs, including instructions, and implementing pawn promotion.

[partner]: https://github.com/jordvnkm

####Screenshot
![image of game](http://res.cloudinary.com/tahngarth825/image/upload/v1468877930/checkmate_rheehe.png)

####Code for deep duping that allows for the undo function
```ruby
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
```

###Demo of game
TODO: SHOW OFF VIDEO

###Instructions to play
1. Download the latest version of [Ruby][ruby]
2. Download the repository and change into its directory
3. In your terminal, run the following commands:
  * `gem install bundler`
  * `bundle install`
  * `ruby lib/game.rb`
4. To quit, press `ctrl`+`c`

###Technical Details
1. Uses the [colorize][colorize] gem to color the board
2. Uses the [cursorable][cursorable] library to recognize keypresses
3. Uses [Ruby][ruby]

[colorize]:
https://rubygems.org/gems/colorize/versions/0.8.1
[ruby]:
https://www.ruby-lang.org/en/downloads/
[cursorable]: https://github.com/rglassett/ruby-cursor-game/blob/master/lib/cursorable.rb

###Features to implement on my own
1. Castling (currently bugged b/c calling can_move_to within castling, yet
  can_move_to checks valid moves)
2. En passe
4. Highlight existing possible moves
100. Refactoring of code


####Notes
In Piece valid_moves, I call can_move_to, yet can_move_to relies on units' valid moves
In bug, it was happening with white king's moves

Right now, valid_moves in piece.rb is with check, and moves in step_piece.rb is
without check. You make a move and then check for being in check, so check for
castle validations only in valid moves, not in moves.   

Make sure valid_moves in piece.rb is working! (last two functions)


Remove debuggers and require byebug
