puts 'display'

require_relative 'board.rb'
require 'colorize'
require_relative 'cursor.rb'

w= 'Write a Display class to handle your rendering logic. Your Display class should access the board.
 Require the colorize gem so you can render in color.'
w= 'set the instance variable @cursor to Cursor.new([0,0], board).'

class Display
  attr_accessor :cursor_pos, :toggle_pos
  def initialize(board, cursor_pos= [0,0])
    @board = board
    @cursor_pos = cursor_pos
    @toggle_pos
  end

  def cursor_pos=(input)
    @cursor_pos= input
  end

  def build_grid
    @board.grid.map.with_index do |row, i|
      build_row(row, i)
    end
  end

  def build_row(row, i)
    row.map.with_index do |piece, j|
      color_options = colors_for(i, j)
      thingy= piece.symbol.to_s+ ' '
      thingy.colorize(color_options)
    end
  end

  def colors_for(i, j)
    if [i,j] == @toggle_pos
      bg= :green
    elsif [i, j] == @cursor_pos
      bg = :red
    elsif (i + j).odd?
      bg = :cyan
    else
      bg = :blue
    end
    { background: bg, color: :pink }
  end


  def render(cursor_pos)
    system("clear")
    puts
    puts "Play chess!"
    build_grid.each { |row| puts row.join }
  end

end
board= Board.new
ib= Display.new(board,[0,0])
cursor= Cursor.new([0,0],board, ib)

cursor.get_input
