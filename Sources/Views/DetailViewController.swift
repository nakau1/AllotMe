// *****************************************************************************
// AllotMe
// (c) NAKAYASU Yuichi all rights reserves.
// *****************************************************************************
import UIKit
import AlamofireImage
import MapKit

class DetailViewController: ViewController {
    
    enum Row {
        case hotelName
        case planName
        case hotelImage
        case image(url: String)
        case baseInfo
        case info(title: String, value: String, link: String?)
        case address
        case summery
        
        var identifier: String {
            switch self {
            case .hotelName:  return "hotelName"
            case .planName:   return "planName"
            case .hotelImage: return "hotelImage"
            case .image:      return "image"
            case .baseInfo:   return "baseInfo"
            case .info:       return "info"
            case .address:    return "address"
            case .summery:    return "summery"
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
        
        var ret: [Row] = [
            .hotelName,
            .planName,
            .hotelImage,
            .baseInfo,
            .address,
        ]
        
        var infos = [Row]()
        infos.append(.info(title: "URL", value: plan.hotelURL, link: plan.hotelURL))
        infos.append(.info(title: "ホテル電話番号", value: plan.tel, link: plan.tel))
        
        if let reservationTel = plan.reservationTel {
            infos.append(.info(title: "予約電話番号", value: reservationTel, link: reservationTel))
        }
        if let lastCheckIn = plan.lastCheckIn {
            infos.append(.info(title: "最終チェックイン", value: lastCheckIn, link: nil))
        }
        if let access = plan.access {
            infos.append(.info(title: "アクセス", value: access, link: nil))
        }
        if let parking = plan.parking {
            infos.append(.info(title: "駐車場", value: parking, link: nil))
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

class DetailHotelNameTableViewCell: DetailTableViewCell {
    
    @IBOutlet private weak var supplierImageView: UIImageView!
    @IBOutlet private weak var nameKanaLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    
    override var plan: Plan! {
        didSet {
            nameKanaLabel.text = plan.hotelNameKana
            nameLabel.text = plan.hotelName
        }
    }
}

class DetailPlanNameTableViewCell: DetailTableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    
    override var plan: Plan! {
        didSet {
            nameLabel.text = plan.planName
        }
    }
}

class DetailHotelImageTableViewCell: DetailTableViewCell {
    
    @IBOutlet private weak var hotelImageView: UIImageView!
    
    override var plan: Plan! {
        didSet {
            if let url = URL(string: plan.imageURLString) {
                hotelImageView.af_setImage(withURL: url)
            } else {
                hotelImageView.image = nil
            }
        }
    }
}

class DetailImageTableViewCell: DetailTableViewCell {
    
    @IBOutlet private weak var pictureImageView: UIImageView!
    
    override var plan: Plan! {
        didSet {
            if let url = self.url {
                pictureImageView.af_setImage(withURL: url)
            } else {
                pictureImageView.image = nil
            }
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
}

class DetailBaseInfoTableViewCell: DetailTableViewCell {
    
    @IBOutlet private weak var priceLabel: UILabel!
    
    override var plan: Plan! {
        didSet {
            
        }
    }
}

class DetailInfoTableViewCell: DetailTableViewCell {
    
    @IBOutlet private weak var captionLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var valueButton: UIButton!
    
    override var plan: Plan! {
        didSet {
            if let info = self.info {
                captionLabel.text = info.title
                valueLabel.text = info.value
            }            
        }
    }
    
    private var info: (title: String, value: String, link: String?)? {
        let row: DetailViewController.Row = self.row
        switch row {
        case let .info(title, value, link):
            return (title: title, value: value, link: link)
        default:
            return nil
        }
    }
}

class DetailAddressTableViewCell: DetailTableViewCell {
    
    @IBOutlet private weak var postalCodeLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var mapView: MKMapView!
    
    override var plan: Plan! {
        didSet {
            postalCodeLabel.text = plan.postalCode
            addressLabel.text = plan.address
        }
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
