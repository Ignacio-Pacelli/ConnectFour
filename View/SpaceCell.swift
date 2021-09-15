
import UIKit

class SpaceCell : UICollectionViewCell {
    
    @IBOutlet weak var chipStatusImage: UIImageView!
    
    func bindSpace(space : Space){
        self.backgroundColor = .white
        if space.chip != nil {
            self.backgroundColor = hexStringToUIColor(hex: (space.chip?.color.hex)!)
        }
    }
    
}
