
import Foundation

struct Player : Equatable{
    static func == (lhs: Player, rhs: Player) -> Bool {
        if(lhs.name == rhs.name){
            return true
        }
        return false
    }
    
    var name: String
    var color: Color
}
