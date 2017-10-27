// *****************************************************************************
// AllotMe
// (c) NAKAYASU Yuichi all rights reserves.
// *****************************************************************************
import UIKit
import AlamofireImage
import MapKit

class DetailViewController: ViewController {
    
    enum Row {
        case baseInfo
        case image(url: String)
        case info(title: String, value: String)
        case link(title: String, value: String, link: Link)
        case summery
        
        enum Link {
            case web(url: String)
            case tel(number: String)
            
            var value: String {
                switch self {
                case let .web(url):    return url
                case let .tel(number): return number
                }
            }
            
            var iconImage: UIImage {
                switch self {
                case .web: return UIImage(named: "icon-safari")!
                case .tel: return UIImage(named: "icon-tel")!
                }
            }
        }
        
        var identifier: String {
            switch self {
            case .baseInfo: return "baseInfo"
            case .image:    return "image"
            case .info:     return "info"
            case .link:     return "link"
            case .summery:  return "summery"
            }
        }
    }
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var plan: Plan!
    private var storedRows: [Row]?
    
    class func create(plan: Plan) -> UIViewController {
        let vc = UIStoryboard(name: "Detail", bundle: nil).instantiateInitialViewController()! as! DetailViewController
        vc.plan = plan
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
    }
    
    private func prepareTableView() {
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private var rows: [Row] {
        if let storedRows = self.storedRows {
            return storedRows
        }
        
        var ret: [Row] = [.baseInfo]
        
        var infos = [Row]()
        infos.append(.link(title: "ホテルHP", value: "サイトを開く", link: .web(url: plan.hotelURL)))
        infos.append(.link(title: "ホテル電話番号", value: plan.tel, link: .tel(number: plan.tel)))
        
        if let reservationTel = plan.reservationTel {
            infos.append(.link(title: "予約電話番号", value: reservationTel, link: .tel(number: reservationTel)))
        }
        if let access = plan.access {
            infos.append(.info(title: "アクセス", value: access))
        }
        if let parking = plan.parking {
            infos.append(.info(title: "駐車場", value: parking))
        }
        ret.append(contentsOf: infos)
        
        plan.imageURLStrings.forEach { imageURLString in
            ret.append(.image(url: imageURLString))
        }
        
        ret.append(.summery)
        return ret
    }
}

extension DetailViewController: DetailTableViewCellDelegate {
    
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: row.identifier, for: indexPath) as! DetailTableViewCell
        cell.delegate = self
        cell.row = row
        cell.plan = plan
        return cell
    }
}

protocol DetailTableViewCellDelegate: class {
    
}

class DetailTableViewCell: UITableViewCell {
    
    var plan: Plan!
    var row: DetailViewController.Row!
    weak var delegate: DetailTableViewCellDelegate!
}

class DetailBaseInfoTableViewCell: DetailTableViewCell {
    
    @IBOutlet private weak var supplierImageView: UIImageView!
    @IBOutlet private weak var hotelNameKanaLabel: UILabel!
    @IBOutlet private weak var hotelNameLabel: UILabel!
    @IBOutlet private weak var planNameLabel: UILabel!
    @IBOutlet private weak var hotelImageView: UIImageView!
    @IBOutlet private weak var hotelSummeryLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var checkInLabel: UILabel!
    @IBOutlet private weak var checkOutLabel: UILabel!
    @IBOutlet private weak var lastCheckInLabel: UILabel!
    @IBOutlet private weak var postalCodeLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var mapView: MKMapView!
    
    override var plan: Plan! {
        didSet {
            setHotelImage(urlString: plan.imageURLString)
            supplierImageView.image = plan.supplier.logoImage
            
            hotelNameKanaLabel.text = plan.hotelNameKana
            hotelNameLabel.text = plan.hotelName
            planNameLabel.text = plan.planName
            hotelSummeryLabel.text = plan.hotelSummery
            priceLabel.text = plan.price.currencyText
            checkInLabel.text = plan.checkIn
            checkOutLabel.text = plan.checkOut
            lastCheckInLabel.text = (plan.lastCheckIn != nil) ? "〜 \(plan.lastCheckIn!)" : ""
            postalCodeLabel.text = plan.postalCode
            addressLabel.text = plan.address
        }
    }
    
    private func setHotelImage(urlString: String) {
        guard let url = URL(string: urlString) else {
            hotelImageView.image = nil
            return
        }
        
        let filter = AspectScaledToFillSizeFilter(size: UIScreen.size(for: 1/2))
        hotelImageView.af_setImage(
            withURL: url,
            placeholderImage: nil,
            filter: filter,
            imageTransition: .crossDissolve(0.5)
        )
    }
}

class DetailInfoTableViewCell: DetailTableViewCell {
    
    @IBOutlet private weak var captionLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    
    override var plan: Plan! {
        didSet {
            if let info = self.info {
                captionLabel.text = info.title
                valueLabel.text   = info.value
            }            
        }
    }
    
    private var info: (title: String, value: String)? {
        let row: DetailViewController.Row = self.row
        switch row {
        case let .info(title, value):
            return (title: title, value: value)
        default:
            return nil
        }
    }
}

class DetailLinkTableViewCell: DetailTableViewCell {
    
    @IBOutlet private weak var captionLabel: UILabel!
    @IBOutlet private weak var valueButton: UIButton!
    
    override var plan: Plan! {
        didSet {
            if let info = self.info {
                captionLabel.text = info.title
                valueButton.setTitle(info.value, for: .normal)
                valueButton.setImage(info.link.iconImage, for: .normal)
            }
        }
    }
    
    private var info: (title: String, value: String, link: DetailViewController.Row.Link)? {
        let row: DetailViewController.Row = self.row
        switch row {
        case let .link(title, value, link):
            return (title: title, value: value, link: link)
        default:
            return nil
        }
    }
}

class DetailImageTableViewCell: DetailTableViewCell {
    
    @IBOutlet private weak var pictureImageView: UIImageView!
    
    override var plan: Plan! {
        didSet {
            setImage(url: self.url)
        }
    }
    
    private var url: URL? {
        let row: DetailViewController.Row = self.row
        switch row {
        case let .image(urlString):
            return URL(string: urlString)
        default:
            return nil
        }
    }
    
    private func setImage(url: URL?) {
        guard let url = url else {
            pictureImageView.image = nil
            return
        }
        
        let filter = AspectScaledToFillSizeFilter(size: UIScreen.size(for: 3/4, padding: 16))
        pictureImageView.af_setImage(
            withURL: url,
            placeholderImage: nil,
            filter: filter,
            imageTransition: .crossDissolve(0.5)
        )
    }
}

class DetailSummeryTableViewCell: DetailTableViewCell {
    
    @IBOutlet private weak var summeryLabel: UILabel!
    
    override var plan: Plan! {
        didSet {
            summeryLabel.text = plan.summery
        }
    }
}
