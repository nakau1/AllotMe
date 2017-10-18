// *****************************************************************************
// AllotMe
// (c) NAKAYASU Yuichi all rights reserves.
// *****************************************************************************
import UIKit
import AlamofireImage

class ListViewController: ViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var presenter: PlanPresentable!
    
    class func create(condition: Condition) -> UIViewController {
        let vc = UIStoryboard(name: "List", bundle: nil).instantiateInitialViewController()! as! ListViewController
        vc.presenter = PlanPresenter(view: vc, condition: condition)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        presenter.loadPlans()
    }
    
    private func prepareTableView() {
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
    }
}

extension ListViewController: PlanViewable {
    
    func willLoadPlans() {
        Hud.show()
    }
    
    func didSucceedLoadPlans() {
        Hud.hide()
        tableView.reloadData()
    }
    
    func didFailedLoadPlans(errorMessage: String) {
        Hud.show(errorMessage)
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.plans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListTableViewCell
        cell.plan = presenter.plans[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DetailViewController.create(plan: presenter.plans[indexPath.row])
        navigation?.push(vc)
    }
}

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var supplierImageView: UIImageView!
    @IBOutlet private weak var hotelNameLabel: UILabel!
    @IBOutlet private weak var thumbImageView: UIImageView!
    @IBOutlet private weak var planNameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private var rateImageViews: [UIImageView]!
    
    var plan: Plan! {
        didSet {
            supplierImageView.image = plan.supplier.iconImage
            hotelNameLabel.text = plan.hotelName
            planNameLabel.text = plan.planName
            priceLabel.text = plan.price.currencyText
            
            if let url = URL(string: plan.thumbURLString) {
                thumbImageView.af_setImage(withURL: url)
            } else {
                thumbImageView.image = nil
            }
            thumbImageView.layer.borderColor = UIColor(white: 1, alpha: 0.7).cgColor
            thumbImageView.layer.borderWidth = 3.5
        }
    }
}
