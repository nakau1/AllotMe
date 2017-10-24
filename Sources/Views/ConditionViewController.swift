// *****************************************************************************
// AllotMe
// (c) NAKAYASU Yuichi all rights reserves.
// *****************************************************************************
import UIKit

class ConditionViewController: ViewController {
    
    enum ConditionItem {
        case today
        case tomorrow
        case dayAfterTomorrow
        case selectDate
        case supplier
        case isNoSmoking
        case hasInternat
        case hasPublicBath
        case hasHotSpring
        case hasBreakfast
        case hasDinner
        case filterHayawari
        case filterGakueari
        case filterMaleOnly
        case filterFamaleOnly
        case filterBirthday
        
        var title: String {
            switch self {
            case .today:            return "今日"
            case .tomorrow:         return "明日"
            case .dayAfterTomorrow: return "明後日"
            case .selectDate:       return "日付を選ぶ"
            case .isNoSmoking:      return "禁煙"
            case .hasInternat:      return "インターネット付き"
            case .hasPublicBath:    return "大浴場付き"
            case .hasHotSpring:     return "温泉付き"
            case .hasBreakfast:     return "朝食付き"
            case .hasDinner:        return "夕食付き"
            case .filterHayawari:   return "「早割」を除く"
            case .filterGakueari:   return "「学割」を除く"
            case .filterMaleOnly:   return "「男性」を除く"
            case .filterFamaleOnly: return "「女性」を除く"
            case .filterBirthday:   return "「誕生日」を除く"
            default: return ""
            }
        }
        
        var summery: String {
            switch self {
            case .filterHayawari: return """
                ホテルが提供するプランには事前の予約で安くなる「早割」が含まれる場合があります。\
                直前の予約の場合は割引が適用されない可能性があります。\
                こちらをオンにすると、プラン名に「早割」というキーワードが入っていた場合は一覧から除外します。
                """
            case .filterGakueari: return """
                ホテルが提供するプランには学生証の提示で安くなる「学割」が含まれる場合があります。\
                社会人の場合は割引が適用されない可能性があります。\
                こちらをオンにすると、プラン名に「学割」というキーワードが入っていた場合は一覧から除外します。
                """
            case .filterMaleOnly: return """
                プランには「男性限定」や「男性の方のみ」という条件が含まれる場合があります。\
                女性の方はホテルを利用できない、または割引されない可能性があります。\
                こちらをオンにすると、プラン名に「男性」というキーワードが入っていた場合は一覧から除外します。
                """
            case .filterFamaleOnly: return """
                プランには「女性限定」や「女性の方のみ」という条件が含まれる場合があります。\
                男性の方はホテルを利用できない、または割引されない可能性があります。\
                こちらをオンにすると、プラン名に「女性」というキーワードが入っていた場合は一覧から除外します。
                """
            case .filterBirthday: return """
                ホテルが提供するプランには宿泊日が誕生日であることで安くなる「誕生日限定サービス」が含まれます。\
                該当しない方には割引が適用されない可能性があります。\
                こちらをオンにすると、プラン名に「誕生日」というキーワードが入っていた場合は一覧から除外します。
                """
            default: return ""
            }
        }
        
        var dateValue: (from: Date, to: Date)! {
            switch self {
            case .today:            return (from: Date().date(addDay: 0), to: Date().date(addDay: 1))
            case .tomorrow:         return (from: Date().date(addDay: 1), to: Date().date(addDay: 2))
            case .dayAfterTomorrow: return (from: Date().date(addDay: 2), to: Date().date(addDay: 3))
            default: return nil
            }
        }
        
        func boolValue(ofCondition condition: Condition) -> Bool {
            switch self {
            case .isNoSmoking:      return condition.isNoSmoking
            case .hasInternat:      return condition.hasInternat
            case .hasPublicBath:    return condition.hasPublicBath
            case .hasHotSpring:     return condition.hasHotSpring
            case .hasBreakfast:     return condition.hasBreakfast
            case .hasDinner:        return condition.hasDinner
            case .filterHayawari:   return condition.filterHayawari
            case .filterGakueari:   return condition.filterGakueari
            case .filterMaleOnly:   return condition.filterMaleOnly
            case .filterFamaleOnly: return condition.filterFamaleOnly
            case .filterBirthday:   return condition.filterBirthday
            default: return false
            }
        }
        
        func setBoolValue(ofCondition condition: inout Condition, value: Bool) {
            switch self {
            case .isNoSmoking:      condition.isNoSmoking      = value
            case .hasInternat:      condition.hasInternat      = value
            case .hasPublicBath:    condition.hasPublicBath    = value
            case .hasHotSpring:     condition.hasHotSpring     = value
            case .hasBreakfast:     condition.hasBreakfast     = value
            case .hasDinner:        condition.hasDinner        = value
            case .filterHayawari:   condition.filterHayawari   = value
            case .filterGakueari:   condition.filterGakueari   = value
            case .filterMaleOnly:   condition.filterMaleOnly   = value
            case .filterFamaleOnly: condition.filterFamaleOnly = value
            case .filterBirthday:   condition.filterBirthday   = value
            default: break
            }
        }
    }
    
    enum Row {
        case caption(title: String)
        case date(item: ConditionItem)
        case bool(item: ConditionItem)
        case supplier
        
        var identifier: String {
            switch self {
            case .caption:  return "caption"
            case .date:     return "date"
            case .bool:     return "bool"
            case .supplier: return "supplier"
            }
        }
        
        var conditionItem: ConditionItem? {
            switch self {
            case let .date(item), let .bool(item):
                return item
            default: return nil
            }
        }
        
        var title: String {
            switch self {
            case let .caption(title):
                return title
            case let .date(item), let .bool(item):
                return item.title
            default: return ""
            }
        }
        
        var summery: String {
            return conditionItem?.summery ?? ""
        }
        
        func boolValue(ofCondition condition: Condition) -> Bool {
            return conditionItem?.boolValue(ofCondition: condition) ?? false
        }
        
        func setBoolValue(ofCondition condition: inout Condition, value: Bool) {
            conditionItem?.setBoolValue(ofCondition: &condition, value: value)
        }
        
        static var rows: [Row] {
            return [
                .caption(title: "宿泊日を選択してください"),
                .date(item: .today),
                .date(item: .tomorrow),
                .date(item: .dayAfterTomorrow),
                .date(item: .selectDate),
                .caption(title: "データの提供元を指定できます"),
                .supplier,
                .caption(title: "絞り込む条件を指定できます"),
                .bool(item: .isNoSmoking),
                .bool(item: .hasInternat),
                .bool(item: .hasPublicBath),
                .bool(item: .hasHotSpring),
                .bool(item: .hasBreakfast),
                .bool(item: .hasDinner),
                .caption(title: "プラン名に含まれる文字を除外することができます"),
                .bool(item: .filterHayawari),
                .bool(item: .filterGakueari),
                .bool(item: .filterMaleOnly),
                .bool(item: .filterFamaleOnly),
                .bool(item: .filterBirthday),
            ]
        }
    }
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var currentCondition = Condition()
    
    class func create(area: Area, pref: Pref) -> UIViewController {
        let vc = UIStoryboard(name: "Condition", bundle: nil).instantiateInitialViewController()! as! ConditionViewController
        vc.currentCondition.area = area
        vc.currentCondition.pref = pref
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        prepareTitle()
    }
    
    private func prepareTitle() {
        title = currentCondition.area.name
    }
    
    private func prepareTableView() {
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
    }
}

extension ConditionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = Row.rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: row.identifier, for: indexPath) as! ConditionTableViewCell
        cell.delegate = self
        cell.condition = currentCondition
        cell.row = row
        return cell
    }
}

extension ConditionViewController: ConditionTableViewCellDelegate {
    
    func cellDidTapDate(from: Date, to: Date) {
        currentCondition.checkInDate  = from
        currentCondition.checkOutDate = to
        navigation?.push(ListViewController.create(condition: currentCondition))
    }
    
    func cellDidTapSelectDate() {
        
    }
    
    func cellDidChangeSuppliers(_ suppliers: [Supplier]) {
        currentCondition.suppliers = suppliers
    }
    
    func cellDidChangeValueSwitch(ofRow row: ConditionViewController.Row, to value: Bool) {
        row.setBoolValue(ofCondition: &self.currentCondition, value: value)
    }
}

protocol ConditionTableViewCellDelegate: class {
    
    func cellDidTapDate(from: Date, to: Date)
    
    func cellDidTapSelectDate()
    
    func cellDidChangeSuppliers(_ suppliers: [Supplier])
    
    func cellDidChangeValueSwitch(ofRow row: ConditionViewController.Row, to value: Bool)
}

class ConditionTableViewCell: UITableViewCell {
    
    var condition: Condition!
    var row: ConditionViewController.Row!
    weak var delegate: ConditionTableViewCellDelegate!
}

class ConditionCaptionTableViewCell: ConditionTableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    override var row: ConditionViewController.Row! {
        didSet {
            titleLabel.text = row.title
        }
    }
}

class ConditionDateTableViewCell: ConditionTableViewCell {
    
    @IBOutlet private weak var dateButton: UIButton!
    
    override var row: ConditionViewController.Row! {
        didSet {
            dateButton.setTitle(row.title, for: .normal)
        }
    }
    
    @IBAction private func didTapDateButton() {
        if row.conditionItem! == .selectDate {
            delegate.cellDidTapSelectDate()
        } else {
            let fromTo = row.conditionItem!.dateValue!
            delegate.cellDidTapDate(from: fromTo.from, to: fromTo.to)
        }
    }
}

class ConditionSwitchTableViewCell: ConditionTableViewCell {
    
    @IBOutlet private weak var valueSwitch: UISwitch!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var summeryLabel: UILabel!
    
    override var row: ConditionViewController.Row! {
        didSet {
            titleLabel.text = row.title
            summeryLabel.text = row.summery
            valueSwitch.isOn = row.boolValue(ofCondition: condition)
        }
    }
    
    @IBAction private func didChangeValueSwitch() {
        delegate.cellDidChangeValueSwitch(ofRow: row, to: valueSwitch.isOn)
    }
}

class ConditionSupplierTableViewCell: ConditionTableViewCell {
    
    @IBOutlet private weak var rakutenButton: UIButton!
    @IBOutlet private weak var jalanButton: UIButton!
    
    override var condition: Condition! {
        didSet {
            rakuten = condition.suppliers.contains(.rakuten)
            jalan   = condition.suppliers.contains(.jalan)
        }
    }
    
    @IBAction private func didTapRakutenButton() {
        if !jalan && rakuten { return }
        rakuten = !rakuten
        informToDelegate()
    }
    
    @IBAction private func didTapJalanButton() {
        if !rakuten && jalan { return }
        jalan = !jalan
        informToDelegate()
    }
    
    private func informToDelegate() {
        var suppliers = [Supplier]()
        if rakuten { suppliers.append(.rakuten) }
        if jalan   { suppliers.append(.jalan) }
        delegate.cellDidChangeSuppliers(suppliers)
    }
    
    private var rakuten: Bool = true {
        didSet {
            let image = UIImage(named: "logo-rakuten-2" + (rakuten ? "" : "-off"))!
            rakutenButton.setImage(image, for: .normal)
        }
    }
    
    private var jalan: Bool = true {
        didSet {
            let image = UIImage(named: "logo-jalan-2" + (jalan ? "" : "-off"))!
            jalanButton.setImage(image, for: .normal)
        }
    }
}
