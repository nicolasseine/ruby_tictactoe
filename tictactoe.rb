# Main class that contains the rules of tictactoe and plays the game
class Game
  def initialize
    @player1 = Player.new
    @player2 = Player.new
    @grid = Grid.new
    @result = nil
    @active_player = Player.list[1]
    @turns = 0
  end

  def game
    @grid.display_grid
    play until @result
    display_result
  end

  def play
    change_player
    @active_player.turn_to_play(@grid)
    @grid.display_grid
    @turns += 1
    check_end_of_game
  end

  def change_player
    @active_player = @active_player == Player.list[0] ? Player.list[1] : Player.list[0]
    puts "It's #{@active_player.name} turn to play"
  end

  def check_end_of_game
    @result = if @active_player.winner
                "victory"
              elsif @turns == 9
                "draw"
              end
  end

  def display_result
    case @result
    when "victory"
      puts "Congrats #{@active_player.name}, you won!"
    when "draw"
      puts "End of the game, nobody won... It's a draw"
    end
  end
end

# A cell has a position and a value. It has neighbours that can make it the winning cell.
class Cell
  attr_accessor :value, :winning_triplets, :playable

  def initialize(num, active_grid)
    @value = num
    @playable = true
    @winning_triplets = []
    active_grid.array << self
  end
end

# A grid is a way to display organised cell values
class Grid
  attr_reader :triplets, :array

  def initialize
    @triplets = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]
    @array = ["array of cells, starting at index 1"]
    (1..9).each do |i|
      Cell.new(i, self)
      get_winning_triplets(@array[i])
    end
  end

  def get_winning_triplets(cell)
    @triplets.each { |triplet| cell.winning_triplets << triplet if triplet.include? cell.value }
  end

  def display_grid
    puts ""
    puts "#{@array[1].value} | #{@array[2].value} | #{@array[3].value}"
    puts "__ __ __"
    puts "#{@array[4].value} | #{@array[5].value} | #{@array[6].value}"
    puts "__ __ __"
    puts "#{@array[7].value} | #{@array[8].value} | #{@array[9].value}"
    puts ""
  end
end

class Player
  require 'colorize'
  @@players = []
  @@symbol_list = ['O'.colorize(:green), 'X'.colorize(:red)]

  attr_reader :symbol, :winner, :name

  def self.list
    @@players
  end

  def initialize
    puts "Player #{@@players.length + 1}, what is your name ?"
    name = gets.chomp
    @name = name
    @symbol = @@symbol_list.delete_at(rand(0..1))
    puts "#{@name}, you will play with #{@symbol}"
    @winner = false
    @@players << self
  end

  def turn_to_play(active_grid)
    choose_number(active_grid)
    @winner = check_victory?(@chosen_cell, active_grid)
  end

  def choose_number(active_grid)
    move = nil
    loop do
      puts "Enter the number of the cell you want to play:"
      move = gets.chomp.to_i
      break if move.positive? && move < 10 && active_grid.array[move].playable
    end
    @chosen_cell = active_grid.array[move]
    @chosen_cell.value = @symbol
    @chosen_cell.playable = false
  end

  def check_victory?(choice, active_grid)
    choice.winning_triplets.each do |triplet|
      test = triplet.map { |i| active_grid.array[i].value }
      if test.all?(@symbol)
        return true
      end
    end
    false
  end
end

Game.new.game
