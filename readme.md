##Chess
This is a version of Chess playable in the terminal that was initially developed in conjunction with my partner [Jordan Minatogawa][partner]. Features that we implemented together include a smart AI that prioritizes higher-value targets and an undo function.

Features that I updated include a choice of 1-player or 2-player, instructions, pawn promotion, castling, en passant, and highlighting of existing possible moves.

[partner]: https://github.com/jordvnkm

###Video Demonstration
(Click video picture to be redirected to Youtube video)
[![video demonstration](https://res.cloudinary.com/tahngarth825/image/upload/v1469382861/Screenshot_from_2016-07-24_10-53-01_gxbzhg.png)](https://youtu.be/vHsiOjKAtUM)

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
###Instructions to play
1. Download the latest version of [Ruby][ruby]
2. Download the repository and change into its directory
3. In your terminal, run the following commands:
  * `gem install bundler`
  * `bundle install`
  * `ruby lib/game.rb`
4. To see instructions, press 'i'
5. To quit, press 'q'

###Technical Details
1. Uses the [colorize][colorize] gem to color the board
2. Uses the [cursorable][cursorable] library to recognize keypresses
3. Uses [Ruby][ruby]

[colorize]:
https://rubygems.org/gems/colorize/versions/0.8.1
[ruby]:
https://www.ruby-lang.org/en/downloads/
[cursorable]: https://github.com/rglassett/ruby-cursor-game/blob/master/lib/cursorable.rb
