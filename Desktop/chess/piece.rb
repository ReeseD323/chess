module Slide
    def generatePossibilities(spots, targetlist)
        upperrow= spots[0]
        lowerrow= spots[1]
        rightcolumn= spots[2]
        leftcolumn= spots[3]
        newspots= spots.select {|i| i <= 7 && i >= 0}
        rows= [upperrow, lowerrow]
        columns= [leftcolumn, rightcolumn] 
        rows.each do |rowe|
            columns.each do |columne|
                if newspots.include?(rowe) && newspots.include?(columne)
                    if self.board.grid[rowe][columne].class.name == "Piece"
                        print 'INVALID MOVE: PIECE THERE : ', [rowe,columne]
                        puts ''
                    end
                    targetlist. append [rowe, columne]
                end
            end
        end
    end
    # steps[0] is how rows is incremented
    # steps[1] is how columns is incremented

    def collisioncheck(row,column)
        if self.board.grid[row][column].class.name != 'Nullpiece'
            print 'COLLISION FOUND @ ', [row,column]
            puts ''
            return true
        end
        false
    end
    def extendrow (row,column, incrementer)
        puts 'extending row....'
        possiblemoves= []
        spacesup= row
        spacesdown= 7-row
        limit= 10
        advrow= row
        if incrementer == 1
            limit = spacesdown
        end
        if incrementer == -1
            limit = spacesup
        end
        puts limit
        (0...limit).each do |i|
            advrow +=  incrementer
            possiblecoordinate= [advrow,column]
            print 'looking at ', advrow, ' , ', column
            puts ''
            if collisioncheck(advrow,column) == true
                return possiblemoves
            end
            possiblemoves << possiblecoordinate
        end
        if possiblemoves.length == 0
            puts 'nO MOVES IN EXTENDED ROW'
        end
        return possiblemoves
    end
    
    def extendcolumn (row,col, incrementer)
        puts 'extending column...'
        possiblemoves= []
        spacesleft= col
        spacesright= 7-col
        limit= 10
        advcol= col
        if incrementer == 1
            limit = spacesright
        end
        if incrementer == -1
            limit = spacesleft
        end
        puts limit
        (0...limit).each do |i|
            advcol +=  incrementer
            possiblecoordinate= [row,advcol]
            print 'looking at ', row, ' , ', advcol
            puts ''
            if collisioncheck(row,advcol) == true
                return possiblemoves
            end
            possiblemoves << possiblecoordinate
        end
        if possiblemoves.length == 0
            puts 'NO MOVES IN EXTENDED COLUMN'
        end
        return possiblemoves
    end

    def generateDiagnol(row,column, steps)
        possiblemoves= [] 
        upperrow= row
        rightcolumn= column
        rowincrement= steps[0]
        columnincrement= steps[1]
        currentrow= row
        currentcolumn= column
        max= [row,column].max
        (max..8).each do |i|
            currentrow += rowincrement
            currentcolumn += columnincrement
            inbounds= [currentrow,currentcolumn].select {|i| i <= 7 && i >= 0}
            if inbounds.length == 2
                collision= false
                if collisioncheck(currentrow,currentcolumn) == true
                    return possiblemoves
                end
                possiblemoves << inbounds
            end
        end
        puts 'NO COLLISION FOUND'
        if possiblemoves.length > 0
            return possiblemoves
        end
        puts 'NO POSSIBLE MOVES'
        return []
    end

    def slideablediag
        coordinates= self.pos
        row= coordinates[0]
        column = coordinates[1]
        upperrow, lowerrow, rightcolumn, leftcolumn= row,row,column,column
        possiblemoves= [] 
        min= [row,column].max
        upperright= upperrow, rightcolumn
        incrementvals= [1,-1]
        incrementvals.each do |i|
            incrementvals.each do |v| 
                directionalarray= generateDiagnol(row,column,[i,v])
                if directionalarray.length > 0
                    directionalarray.each {|i| possiblemoves.append i }
                end
            end
        end
        return possiblemoves
        puts ''
    end

    def kingmovement
        possiblemoves= []
        coordinates= self.pos
        row= coordinates[0]
        column = coordinates[1]
        posrow, poscol= row, column
        [1,0,-1].each do |i|
            posrow= row
            posrow += i
            [1,0,-1].each do |r|
                poscol = column
                poscol += r 
                print [posrow,poscol]
                puts
                if collisioncheck(posrow,poscol) == false
                    possiblemoves.append [posrow,poscol]
                end
            end
        end
        return possiblemoves
    end

    def horsemovement
        possiblemoves= []
        coordinates= self.pos
        row= coordinates[0]
        column = coordinates[1]
        #over 1 up 3
        rowpositions= [row+2,row-2]
        columnpositions= [column+1,column-1]
        rowpositions.each do |rowe|
            columnpositions.each do |col|
                print [rowe,col]
                puts
                newcor= [rowe,col].select {|i| i > -1 && i < 8}
                puts collisioncheck(rowe,col)
                if collisioncheck(rowe,col) == false && newcor.length ==2
                    possiblemoves.append [newcor[0],newcor[1]]
                    puts''
                end
            end
        end
        columnpositions= [column+2,column-2]
        rowpositions= [row+1,row-1]
        rowpositions.each do |rowe|
            columnpositions.each do |col|
                print [rowe,col]
                puts
                newcor= [rowe,col].select {|i| i > -1 && i < 8}
                puts collisioncheck(rowe,col)
                if collisioncheck(rowe,col) == false && newcor.length == 2
                    possiblemoves.append [rowe,col]
                    puts''
                end
            end
        end
        print possiblemoves
        puts
        return possiblemoves
    end

    def pawnmovement
        coordinates= self.pos
        color = self.color
        row= coordinates[0]
        column = coordinates[1]
        increment= [-1,1]
        if color== 'black'
            if row == 1
                if collisioncheck(row+2,column) == false && collisioncheck(row+1,column) == false
                    return [[row+1,column],[row+2,column]]
                else
                    return [[row+1,column]]
                end
            end
            return [[row+1, column]] if collisioncheck(row+1,column) == false
        end
        if color== 'white'
            if row == 1
                if collisioncheck(row-2,column) == false && collisioncheck(row-1,column) == false
                    return [[row-1,column],[row-2,column]]
                else
                    return [[row-1,column]]
                end
            end
            return [[row-1, column]] if collisioncheck(row-1,column) == false
        end
    end



    def generateStraight(coordinate1,coordinate2)
        puts 'Starting to generate moves...'
        possiblemoves= [] 
        highercoordinate, lowercoordinate = coordinate1,coordinate2
        spacesup= coordinate1
        spacesdown= 7-coordinate1
        max= [spacesup,spacesdown].max
        skipup= false
        skipdown= false
        (0..max).each do |i|
            puts i
            lowercoordinate -= 1
            possiblecoordinate= [lowercoordinate,coordinate2]
            print 'looking at ', lowercoordinate, ' , ', coordinate2
            puts ''
            if skipdown == true
                next
            end
            if collisioncheck(lowercoordinate,coordinate2) == true
                skipdown= true
                next
            end
            if collisioncheck(lowercoordinate,coordinate2) == false
                print possiblecoordinate
                puts''
                possiblemoves << possiblecoordinate
            end
        end
        if possiblemoves.length > 0
            return possiblemoves
        end
        puts "NO POSSIBLE MOVES"
    end

    def slideablestraight
        coordinates= self.pos
        row= coordinates[0]
        column = coordinates[1]
        posibilities= []
        #find up and down coordinates
        [1,-1].each do |i|
            rowpos= extendrow(row,column, i)
            colpos= extendcolumn(row,column, i)
            [rowpos,colpos].each do |lis|
                lis.each do |item|
                    posibilities.append item
                end
            end
        end
        return posibilities
    end

end

class Piece 
    include Slide
    attr_reader :color,:board, :pos
    def initialize(color= nil, board, pos)
        @color = color
        @board = board
        @pos = pos
        @symbol
    end
end

class Rook < Piece
    def possiblemoves
        print slideablestraight
        return slideablestraight
    end
    def symbol
        return ' ♜ ' if self.color == 'black'
        return ' ♖ ' if self.color == 'white'
    end
end


class Bishop < Piece
    def possiblemoves
        print slideablediag
        return slideablediag
    end

    def symbol
        return ' ♝ ' if self.color == 'black'
        return ' ♗ ' if self.color == 'white'
    end
end


class Knight < Piece
    def possiblemoves
        print horsemovement
        return horsemovement
    end

    def symbol
        return ' ♞ ' if self.color == 'black'
        return ' ♘ ' if self.color == 'white'
    end
end


class Queen < Piece
    def possiblemoves

        return slideablediag.concot(slideablestriaght)
    end

    def symbol
        return ' ♛ ' if self.color == 'black'
        return ' ♕ ' if self.color == 'white'
    end
end

class King < Piece
    def possiblemoves
        print kingmovement
        return kingmovement
    end

    def symbol
        return ' ♚ ' if self.color == 'black'
        return ' ♔ ' if self.color == 'white'
    end
    
end

class Pawn < Piece
    def possiblemoves
        print 'possible moves: ' , pawnmovement
        return pawnmovement
    end

    def symbol
        return ' ♟ ' if self.color == 'black'
        return ' ♙ ' if self.color == 'white'
    end
end

class Nullpiece < Piece
    def initialize(color,board,pos)
        @symbol= nil 
        @board= board
        @pos= pos
    end
    def symbol
        return '   '
    end
end






oldcode=     '(min..9).each do |i|
upperrow -= 1 
lowerrow += 1
rightcolumn +=1
leftcolumn -=1
spots= [upperrow,lowerrow,rightcolumn,leftcolumn]
#must be fed spots in this order
generatePossibilities(spots, possiblespots)
end
puts '