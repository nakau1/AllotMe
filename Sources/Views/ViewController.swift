// *****************************************************************************
// AllotMe
// (c) NAKAYASU Yuichi all rights reserves.
// *****************************************************************************
import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareBackgroundColor()
    }
    
    var navigation: Navigation? {
        if let navigation = self.parent as? Navigation {
            return navigation
        }
        return nil
    }
    
    func prepareBackgroundColor() {
        view.backgroundColor = .clear
    }
    
    func notifyChangeBackground(pref: Pref?) {
        NotificationCenter.default.post(
            name: .ChangeBackground,
            object: nil,
            userInfo: [
                Notification.InfoKey.ChangingBackgroundImageKey: pref?.backgroundImage
            ]
        )
    }
}

extension UIViewController {
    
//    var withNavigation: UIViewController {
//        return UINavigationController(rootViewController: self)
//    }
    
    var withNavigation: UIViewController {
        return Navigation.create(rootViewController: self)
    }
}
