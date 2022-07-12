

class Piece 
    attr_reader :symbol,:board, :pos
    def initialize(symbol, board, pos)
        @symbol = symbol
        @board = board
        @pos = pos
    end

    def symbol
        @symbol
    end

end