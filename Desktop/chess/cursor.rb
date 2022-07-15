require "io/console"


KEYMAP = {
  " " => :space,
  "h" => :left,
  "j" => :down,
  "k" => :up,
  "l" => :right,
  "w" => :up,
  "a" => :left,
  "s" => :down,
  "d" => :right,
  "\t" => :tab,
  "\r" => :return,
  "\n" => :newline,
  "\e" => :escape,
  "\e[A" => :up,
  "\e[B" => :down,
  "\e[C" => :right,
  "\e[D" => :left,
  "\177" => :backspace,
  "\004" => :delete,
  "\u0003" => :ctrl_c,
}

MOVES = {
  left: [0, -1],
  right: [0, 1],
  up: [-1, 0],
  down: [1, 0]
}

class Cursor

  attr_reader :cursor_pos, :board, :display

  def initialize(cursor_pos= [0,0], board, display)
    @cursor_pos = cursor_pos
    @board = board
    @display= display
    @display.render(cursor_pos)
  end

  def get_input
    input= read_char
    if KEYMAP[input] == nil
        puts 'INPUT NOT RECOGNIZED, TRY A VALID CHARACTER'
    else
        key= KEYMAP[input]
        handle_key(key)
    end
  end

  private

  def read_char
    STDIN.echo = false # stops the console from printing return values

    STDIN.raw! # in raw mode data is given as is to the program--the system
                 # doesn't preprocess special characters such as control-c

    input = STDIN.getc.chr # STDIN.getc reads a one-character string as a
                             # numeric keycode. chr returns a string of the
                             # character represented by the keycode.
                             # (e.g. 65.chr => "A")

    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil # read_nonblock(maxlen) reads
                                                   # at most maxlen bytes from a
                                                   # data stream; it's nonblocking,
                                                   # meaning the method executes
                                                   # asynchronously; it raises an
                                                   # error if no data is available,
                                                   # hence the need for rescue

      input << STDIN.read_nonblock(2) rescue nil
    end
    #line of code below was throwing errors so I commented it out
    #STDIN.echo = true # the console prints return values again
    STDIN.cooked! # the opposite of raw mode :)

    return input
  end


  def handle_key(key)
    puts 'handle key triggered: ', key

    case key

    when :up
        update_pos(MOVES[:up])
    when :down
        update_pos(MOVES[:down])
    when :right 
        update_pos(MOVES[:right])
    when :left
        update_pos(MOVES[:left])
    when :space
        display.toggle_pos= @cursor_pos
        display.render(@cursor_pos)
        selected= 
        return @cursor_pos
    when :return
        display.toggle_pos= @cursor_pos
        display.render(@cursor_pos)
        return cursor_pos
    end
  end


  def update_pos(diff)
    row, column = cursor_pos[0], cursor_pos[1]
    row += diff[0]
    column += diff[1]
    @cursor_pos = [row,column]
    print 'cursor position updated to: ', @cursor_pos
    puts
    display.cursor_pos= @cursor_pos
    display.render(@cursor_pos)
    get_input
    
  end
end