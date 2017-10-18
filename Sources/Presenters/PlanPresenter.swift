// *****************************************************************************
// AllotMe
// (c) NAKAYASU Yuichi all rights reserves.
// *****************************************************************************
import Foundation

protocol PlanPresentable: class {
    
    var plans: [Plan] { get }
    
    func loadPlans()
}

protocol PlanViewable: class {
    
    func willLoadPlans()
    func didSucceedLoadPlans()
    func didFailedLoadPlans(errorMessage: String)
}

class PlanPresenter {
    
    weak var view: PlanViewable!
    var condition: Condition
    
    private(set) var plans = [Plan]()
    
    init(view: PlanViewable, condition: Condition) {
        self.view = view
        self.condition = condition
    }
}

extension PlanPresenter: PlanPresentable {
    
    func loadPlans() {
        view.willLoadPlans()
        
        let rakuten = RakutenRequest(condition: condition)
        WebAPI.request(rakuten) { [unowned self] response, result in
            if result.ok {
                self.plans = response?.plans ?? []
                self.view.didSucceedLoadPlans()
            } else {
                self.view.didFailedLoadPlans(errorMessage: "エラー")
            }
        }
    }
}
