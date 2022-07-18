
require_relative 'piece.rb' 
#Your Board class should hold a 2-dimensional array 
#Each position in the board either holds a moving Piece
# or a NullPiece (NullPiece will inherit from Piece).
class Board
    def initialize
        @grid= Array.new(7) {Array.new(6) }
        pawnzone= [1,6]
        pawnzone.each do |row|
            #puts "row ", row
            for pos in (0..7)
                white= 'white'
                black= 'black'
                if row == 1
                    color= black
                end
                if row == 6
                    color= white
                end
                position= [row,pos]
                @grid[row][pos] = Pawn.new(color, self, position)
            end
        end
        therow= [0,7]
        black= 'black'
        white= 'white'
        deadspace= [2,3,4,5]
        deadspace.each do |row|
            (0..7).each do |item|
                filler = Nullpiece.new(nil, self, [row,item])
                @grid[row][item]= filler
            end
        end
        order= [Rook.new(black, self, [0,0]), Knight.new(black, self, [0,1]), Bishop.new(black,self,[0,2]), 
        Queen.new(black,self,[0,3]), King.new(black,self,[0,4]),Bishop.new(black,self,[0,5]), 
        Knight.new(black,self,[0,6]),Rook.new(black,self,[0,7])]

        orderlast= [Rook.new(white, self, [7,0]), Knight.new(white, self, [7,1]), Bishop.new(white,self,[7,2]), 
        Queen.new(white,self,[7,3]), King.new(white,self,[7,4]),Bishop.new(white,self,[7,5]), 
        Knight.new(white,self,[7,6]),Rook.new(white,self,[7,7])]

        @grid.unshift(order)
        @grid.append(orderlast)
        @grid.delete_at(1)

    end
    def grid
        return @grid
    end
    #dead code below, replaced by putting into intialize
    def insert
        pawnzone= [1,6]
        pawnzone.each do |row|
            #puts "row ", row
            for pos in (0..7)
                white= 'white'
                black= 'black'
                if row == 1
                    color= black
                end
                if row == 6
                    color= white
                end
                position= [row,pos]
                @grid[row][pos] = Pawn.new(color, self, position)
            end
        end
        therow= [0,7]
        black= 'black'
        white= 'white'
        deadspace= [2,3,4,5]
        deadspace.each do |row|
            (0..7).each do |item|
                filler = Nullpiece.new(nil, self, [row,item])
                @grid[row][item]= filler
            end
        end
        order= [Rook.new(black, self, [0,0]), Knight.new(black, self, [0,1]), Bishop.new(black,self,[0,2]), 
        Queen.new(black,self,[0,3]), King.new(black,self,[0,4]),Bishop.new(black,self,[0,5]), 
        Knight.new(black,self,[0,6]),Rook.new(black,self,[0,7])]

        orderlast= [Rook.new(white, self, [7,0]), Knight.new(white, self, [7,1]), Bishop.new(white,self,[7,2]), 
        Queen.new(white,self,[7,3]), King.new(white,self,[7,4]),Bishop.new(white,self,[7,5]), 
        Knight.new(white,self,[7,6]),Rook.new(white,self,[7,7])]

        @grid.unshift(order)
        @grid.append(orderlast)
        @grid.delete_at(1)
        
    end
    def prin
        (0..2).each {|n| puts} 
        prinboard= []
        @grid.each do |line|
            linelist= []
            line.each do |item|
                linelist.append  item.class.name
            end
            prinboard.append linelist
        end

        prinboard.each_with_index do |line, idx|
            print idx, ' ', line
            puts '' *1
        end
    end
    def move_piece(start ,endpos)
        puts "grid coordinate contents ; ", @grid[start[0]][start[1]]
        piece= @grid[start[0]][start[1]]
        endpospiece= @grid[endpos[0]][endpos[1]]
        piececolor= piece.color
        #list of possible moves generated
        possiblecoordinates= piece.possiblemoves
        validcoordinate= false
        nilcoordinate= false
        if piece.class.name == 'Nullpiece' || endpospiece.class.name == 'NullPiece'
            nilcoordinate= true
            puts "NIL COORDINATE"
            return
        end
        if piece != nil && endpospiece != nil
            validcoordinate= true
        end
        if validcoordinate == true && nilcoordinate== false
            print 'possible coordinates for selected position is: ', possiblecoordinates[0]
            puts
            if possiblecoordinates.include?(endpos)
                puts 'VALID MOVE SELECTED'
                grid[endpos[0]][endpos[1]]= piece
                piece.pos= [endpos[0],endpos[1]]
                @grid[start[0]][start[1]]= Nullpiece.new(nil,self,[start[0],start[1]])
            else 
                print 'POSITION NOT A POSSIBLE MOVE FOR SELECTED PIECE: ', piece.class.name
                puts
                print possiblecoordinates
                puts
             end
            
        else
            puts "INVALID COORDINATE"
        end
    end

end

board= Board.new
rookie= board.grid[0][0]
puts rookie.symbol



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
