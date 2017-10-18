// *****************************************************************************
// AllotMe
// (c) NAKAYASU Yuichi all rights reserves.
// *****************************************************************************
import UIKit

class Navigation: UIViewController {
        
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var navigationArea: UIView!
    @IBOutlet private weak var contentsArea: UIView!
    
    private var rect: CGRect!
    
    class func create(rootViewController: UIViewController) -> Navigation {
        let vc = UIStoryboard(name: "Navigation", bundle: nil).instantiateInitialViewController()! as! Navigation
        vc.addChildViewController(rootViewController)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareBackgroundColor()
        prepareBackButtonImage()
    }
    
    private func prepareBackgroundColor() {
        view.backgroundColor = .clear
    }
    
    private func prepareBackButtonImage() {
        backButton.setImage(backButtonImage, for: .normal)
    }
    
    private var layouted = false
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !layouted  {
            prepareRootViewController()
            layouted = true
        }
    }
    
    private func prepareRootViewController() {
        let root = childViewControllers.first!
        
        rect = contentsArea.frame
        root.view.frame = rect
        contentsArea.removeFromSuperview()
        
        view.addSubview(root.view)
        titleText = root.title
        backButtonVisible = false
        root.viewWillAppear(false)
        root.viewDidAppear(false)
    }
    
    func push(_ viewController: UIViewController) {
        guard let last = childViewControllers.last else { return }
        self.addChildViewController(viewController)
        showContents(left: last, right: viewController, toRight: true) {
            last.view.removeFromSuperview()
            if self.childViewControllers.count >= 2 {
                self.backButtonVisible = true
            }
        }
    }
    
    func pop() {
        if childViewControllers.count < 2 { return }
        
        let last = childViewControllers.last!
        let beforeLast = childViewControllers.beforeLast!
        
        if childViewControllers.beforeLastIsFirst {
            self.backButton.isHidden = true
        }
        
        showContents(left: beforeLast, right: last, toRight: false) {
            last.view.removeFromSuperview()
            last.removeFromParentViewController()
        }
    }
    
    @IBAction private func didTapBackButton() {
        pop()
    }
    

    
    private func showContents(left: UIViewController, right: UIViewController, toRight: Bool, completed: @escaping ()->()) {
        left.view.frame  = toRight ? centerFrame : leftFrame
        right.view.frame = toRight ? rightFrame : centerFrame
        
        addSubviewIfNeeded(left)
        addSubviewIfNeeded(right)
        
        if toRight {
            right.viewWillAppear(true)
            left.viewWillDisappear(true)
            titleText = right.title
        } else {
            left.viewWillAppear(true)
            right.viewWillDisappear(true)
            titleText = left.title
        }
        
        UIView.animate(
            withDuration: 0.32,
            animations: {
                left.view.frame  = toRight ? self.leftFrame   : self.centerFrame
                right.view.frame = toRight ? self.centerFrame : self.rightFrame
            },
            completion: { finished in
                if toRight {
                    right.viewDidAppear(true)
                    left.viewDidDisappear(true)
                } else {
                    left.viewDidAppear(true)
                    right.viewDidDisappear(true)
                }
                completed()
            }
        )
    }
    
    private var leftFrame: CGRect {
        var ret = rect!
        ret.origin.x = -rect.width
        return ret
    }
    
    private var centerFrame: CGRect {
        var ret = rect!
        ret.origin.x = 0
        return ret
    }
    
    private var rightFrame: CGRect {
        var ret = rect!
        ret.origin.x = rect.width
        return ret
    }
    
    private func addSubviewIfNeeded(_ viewController: UIViewController) {
        if viewController.view.superview == nil {
            view.addSubview(viewController.view)
        }
    }
    
    private var backButtonImage: UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 100, height: 100))
        let context = UIGraphicsGetCurrentContext()!
        
        context.setLineWidth(8)
        context.move(to: CGPoint(x: 60, y: 30))
        context.addLine(to: CGPoint(x: 40, y: 50))
        context.addLine(to: CGPoint(x: 60, y: 70))
        context.setStrokeColor(UIColor.white.cgColor)
        context.setLineCap(.round)
        context.strokePath()
        
        let ret = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return ret!
    }
    
    private var backButtonVisible: Bool {
        get { return !backButton.isHidden }
        set { backButton.isHidden = !newValue }
    }
    
    private var titleText: String? {
        get { return titleLabel.text ?? "" }
        set { titleLabel.text = newValue ?? "" }
    }
}
