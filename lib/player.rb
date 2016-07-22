class Player
  attr_accessor :name, :color

  def initialize(name, color)
    @name = name
    @color = color
  end

  def get_move

  end

  def prompt_en_passant
    #handled in child
  end

  def handle_en_passant
    #handled in child
  end
end
