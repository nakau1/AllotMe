// *****************************************************************************
// AllotMe
// (c) NAKAYASU Yuichi all rights reserves.
// *****************************************************************************
import UIKit

class AreaViewController: ViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var pref: Pref!
    
    class func create(pref: Pref) -> UIViewController {
        let vc = UIStoryboard(name: "Area", bundle: nil).instantiateInitialViewController()! as! AreaViewController
        vc.pref = pref
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        prepareTitle()
    }
    
    private func prepareTitle() {
        title = pref.japanese
    }
    
    private func prepareTableView() {
        tableView.estimatedRowHeight = 82
        tableView.rowHeight = UITableViewAutomaticDimension
    }
}

extension AreaViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Area.items(of: pref).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AreaTableViewCell
        cell.area = Area.items(of: pref)[indexPath.row]
        cell.bottomLineVisible = (indexPath.row == Area.items(of: pref).lastIndex)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let area = Area.items(of: pref)[indexPath.row]
        let vc = ConditionViewController.create(area: area, pref: pref)
        navigation?.push(vc)
    }
}

class AreaTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var bottomLine: UIView!
    
    var area: Area! {
        didSet {
            nameLabel.text = area.name
        }
    }
    
    var bottomLineVisible: Bool = true {
        didSet {
            bottomLine.isHidden = !bottomLineVisible
        }
    }
}
