
import Foundation

struct Color : Equatable{
    
    static func == (lhs: Color, rhs: Color) -> Bool {
        if(lhs.hex == rhs.hex){
            return true
        }
        return false
    }
    
    var hex: String
}
