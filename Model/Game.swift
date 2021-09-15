
import Foundation


struct Game {
    
    enum InsertResult {
        case failed_column_filled
        case success_with_winner
        case success_without_winner
        case success_with_board_full
    }
    
    var id: Int
    var player1: Player
    var player2: Player
    var currentPlayer: Player
    var spaces: [Space]
    let rows: Int = 6
    let columns: Int = 7
    
    init(id: Int, player1: Player, player2: Player, currentPlayer: Player) {
        //We create new empty spaces
        self.spaces = [Space]()
        for _ in 0...rows*columns-1 {
            let space = Space(chip: nil)
            self.spaces.append(space)
        }
        //We assign players
        self.id = id
        self.player1 = player1
        self.player2 = player2
        self.currentPlayer = currentPlayer
    }
    
    mutating func reset(){
        //We set again new spaces
        self.spaces = [Space]()
        for _ in 0...rows*columns-1 {
            let space = Space(chip: nil)
            self.spaces.append(space)
        }
        self.currentPlayer = player1
    }
    
    func checkBoardFull() -> Bool {
        var counter = 0
        for i in 0...rows*columns-1 {
            if(spaces[i].chip != nil){
                counter+=1
            }
        }
        return (counter==rows*columns)
    }
    
    func checkWinner() -> Bool{
        
        if(checkVerticalWin(player: currentPlayer, spaces: spaces, rows: rows, columns: columns) == true){
            return true
        }
        
        if(checkHorizontallWin(player: currentPlayer, spaces: spaces, rows: rows, columns: columns) == true){
            return true
        }
        
        if (checkDiagonalRightWin(player: currentPlayer, spaces: spaces, rows: rows, columns: columns) == true) {
            return true
        }
        
        if (checkDiagonalLeftWin(player: currentPlayer, spaces: spaces, rows: rows, columns: columns) == true) {
            return true
        }
        
        return false
    }
    
    func checkVerticalWin(player : Player, spaces : [Space], rows : Int, columns : Int) -> Bool {
        for col in 0...columns-1{
            var counter = 0
            for i in stride(from: col, to: rows*columns, by: columns){
                if(spaces[i].chip != nil){
                    if(spaces[i].chip?.color == player.color){
                        counter+=1
                        if(counter==4){
                            return true
                        }
                    }
                    //reset counter when there´s a chip from the other player
                    else{
                        counter=0
                    }
                }
            }
        }
        return false
    }
    
    func checkHorizontallWin(player : Player, spaces : [Space], rows : Int, columns : Int) -> Bool {
        for i in stride(from: 0, to: columns*rows, by: columns){
            var counter = 0
            for j in stride(from: i, to: i+columns, by: 1){
                if(spaces[j].chip != nil){
                    if(spaces[j].chip!.color == currentPlayer.color){
                        counter+=1
                        if(counter==4){
                            return true
                        }
                    }
                    //reset counter when there´s a chip from the other player
                    else{
                        counter=0
                    }
                }
                //reset counter when there´s a space in the middle
                else{
                    counter=0
                }
                
            }
        }
        return false
    }
    
    func checkDiagonalRightWin(player : Player, spaces : [Space], rows : Int, columns : Int) -> Bool {
        for i in stride(from: 0, to: columns, by: 1){
            var counter = 0
            for j in stride(from: i, to: columns*rows, by: columns+1){
                if(spaces[j].chip != nil){
                    if(spaces[j].chip!.color == currentPlayer.color){
                        counter+=1
                        if(counter==4){
                            return true
                        }
                    }
                    //reset counter when there´s a chip from the other player
                    else{
                        counter=0
                    }
                }
                //reset counter when there´s a space in the middle
                else{
                    counter=0
                }
            }
        }
        return false
    }
    
    func checkDiagonalLeftWin(player : Player, spaces : [Space], rows : Int, columns : Int) -> Bool {
        for i in stride(from: 0, to: columns, by: 1){
            var counter = 0
            for j in stride(from: i, to: columns*rows, by: columns-1){
                if(spaces[j].chip != nil){
                    if(spaces[j].chip!.color == currentPlayer.color){
                        counter+=1
                        if(counter==4){
                            return true
                        }
                    }
                    else{
                        counter=0
                    }
                }
                //reset counter when there´s a space in the middle
                else{
                    counter=0
                }
            }
        }
        return false
    }
    
    mutating func changeTurn(){
        if(currentPlayer == player1){
            self.currentPlayer = player2
        }
        else{
            self.currentPlayer = player1
        }
    }
    
    mutating func insertChipInColumn(column : Int) -> InsertResult {
        
        //We count how many chips are already in the given column
        var sum = 0
        for i in stride(from: column, to: columns*rows, by: columns){
            if spaces[i].chip != nil {
                sum+=1
            }
        }
        
        //If the column is already full...
        if(sum >= rows){
            return InsertResult.failed_column_filled
        }
        else{
            //If the column is still not full, we insert and check for winner
            let chip1 = Chip(color: currentPlayer.color)
            let pointer = ((rows-sum-1)*columns)+column
            spaces[pointer].chip = chip1
            
            if checkWinner() == true {
                return InsertResult.success_with_winner
            }
            else{
                if checkBoardFull() {
                    return InsertResult.success_with_board_full
                }
                changeTurn()
                return InsertResult.success_without_winner
            }
        }
    }
}
