class Box
  def initialize
    @status = "_"
  end
  def status
    @status
  end
  def place(mark)
    if @status != "_"
      puts "This spot is already occupied."
    else
      @status = mark
    end
  end
end

class Board
  attr_accessor :spots
  def initialize
    @spots = []
    (0..8).each do |x|
      @spots << Box.new
    end
    @win = false
    @draw = false
  end
  def win
    @win
  end
  def draw
    @draw
  end
  def display
    puts ""
    puts "|#{@spots[0].status} #{@spots[1].status} #{@spots[2].status}|"
    puts "|#{@spots[3].status} #{@spots[4].status} #{@spots[5].status}|"
    puts "|#{@spots[6].status} #{@spots[7].status} #{@spots[8].status}|"
    puts ""
  end
  def status_update(turn)
    win_conditions = [[0,1,2],[0,3,6],[0,4,8],[1,4,7],[2,4,6],[2,5,8],[3,4,5],[6,7,8]]
    win_conditions.each do |places|
      if check_match(places,0,1) && check_match(places,1,2) && check_match(places,2,"_")
        @win = true
        break
      end
    end
    if turn >= 8
      @draw = true
    end
  end
  def check_match(places,i,j)
    if j == "_"
      @spots[places[i]].status != "_"
    else
      @spots[places[i]].status == @spots[places[j]].status
    end
  end
end

def new_game?
  puts "Start a new game? Yes/No"
  answer = gets.chomp.downcase
  puts ""
  $quit = (answer == "no" || answer == "n")
end

$quit = false
until $quit
  puts "Welcome to Tic-Tac-Toe! Let's play a game!"
  game_board = Board.new
  game_board.display
  turn = 0
  win = false
  draw = false
  until win || draw
    puts "Player #{turn % 2 +1}, make your move."
    move = (turn % 2) == 0 ? "X" : "O"
    puts move
    spot = gets.chomp.to_i
    case spot
    when 1..9
      turn -= 1 if game_board.spots[spot - 1].status != "_"
      game_board.spots[spot - 1].place(move)
    else
      puts "Please choose a spot from 1-9."
      turn -= 1
    end
    game_board.display
    game_board.status_update(turn)
    win = game_board.win
    draw = game_board.draw
    turn +=1
  end
  if win
    puts "Congratulations, Player #{turn % 2 == 0 ? 2 : 1}! You have won the game!"
    new_game?
  else
    puts "The game is a draw."
    new_game?
  end
end
