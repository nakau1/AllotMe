// *****************************************************************************
// AllotMe
// (c) NAKAYASU Yuichi all rights reserves.
// *****************************************************************************
import UIKit

class BaseViewController: ViewController {
    
    @IBOutlet private weak var backgroundImageView: UIImageView!
    
    class func create() -> UIViewController {
        return UIStoryboard(name: "Base", bundle: nil).instantiateInitialViewController()! as! BaseViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViewController()
        prepareObserving()
    }
    
    private func prepareViewController() {
        let vc = PrefViewController.create()
        addChildViewController(vc)
        view.addSubview(vc.view)
    }
    
    private func prepareObserving() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceiveChangeBackground(notification:)),
            name: .ChangeBackground,
            object: nil
        )
    }
    
    @objc private func didReceiveChangeBackground(notification: Notification) {
        let image = notification.userInfo?[Notification.InfoKey.ChangingBackgroundImageKey] as? UIImage
        backgroundImageView.image = image
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension Notification.InfoKey {
    static let ChangingBackgroundImageKey = "BaseViewController.changingBackgroundImage"
}

extension Notification.Name {
    static let ChangeBackground = Notification.Name("BaseViewController.changeBackground")
}
