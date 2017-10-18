// *****************************************************************************
// AllotMe
// (c) NAKAYASU Yuichi all rights reserves.
// *****************************************************************************
import UIKit

enum Supplier: String {
    case rakuten
    case jalan
    
    var iconImage: UIImage {
        return UIImage(named: "logo-\(self.rawValue)-small")!
    }
    
    var logoImage: UIImage {
        return UIImage(named: "logo-\(self.rawValue)")!
    }
}
