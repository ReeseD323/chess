
require_relative 'piece.rb' 
#Your Board class should hold a 2-dimensional array 
#Each position in the board either holds a moving Piece
# or a NullPiece (NullPiece will inherit from Piece).
class Board
    def initialize
        @grid= Array.new(8) {Array.new(8) }
    end
    def insert
        area= [0,1,6,7]
        area.each do |row|
            #puts "row ", row
            for pos in (0..7)
                position= [row,pos]
                @grid[row][pos] = Piece.new("pawn", self, position )
            end
        end
    
    end
    def prin
        prinboard= []
        @grid.each do |line|
            linelist= []
            line.each do |item|
                puts item.class.name
                if item.class.name == 'Piece'
                    linelist.append item.symbol
                else
                    linelist.append item
                end
            end
            prinboard.append linelist
        end

        prinboard.each do |line|
            print line
            puts '' *7
        end
    end
    def move_piece(start,endpos)
        movee = @grid[start[0]][start[1]]
        @grid[endpos[0]][endpos[1]]= movee
        @grid[start[0]][start[1]] = nil
        self.prin
    end

end

test= Board.new
test.insert
test.prin
test.move_piece([0,0],[4,4])


#Sliding pieces (Bishop/Rook/Queen)

#Stepping pieces (Knight/King)

#Null pieces (occupy the 'empty' spaces)

#Pawns (we'll do this class last)

#To start off, you'll want to create an empty Piece 
#class as a placeholder for now. Write code for
 #initialize so we can setup the board with instances 
 #of Piece in locations where a Queen/Rook/Knight/ 
 #etc. will start and nil where the NullPiece will 
 #start.

#The Board class should have a #move_piece(start_pos,
# end_pos) method. This should update the 2D grid and 
#also the moved piece's position. You'll want to raise
## an exception if:

#there is no piece at start_pos or
#the piece cannot move to end_pos.
#Time to test! Open up pry and load 'board.rb'. 
#Create an instance of Board and check out different
# positions with board[pos]. Do you get back Piece 
#instances where you expect to? Test out 
#Board#move_piece(start_pos, end_pos), does it raise an
# error when there is no piece at the start? Does it 
#successfully update the Board?
