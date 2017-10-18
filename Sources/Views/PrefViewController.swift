// *****************************************************************************
// AllotMe
// (c) NAKAYASU Yuichi all rights reserves.
// *****************************************************************************
import UIKit

class PrefViewController: ViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    class func create() -> UIViewController {
        return UIStoryboard(name: "Pref", bundle: nil).instantiateInitialViewController()!.withNavigation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTitle()
    }
    
    private func prepareTitle() {
        title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notifyChangeBackground(pref: nil)
    }
}

extension PrefViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, PrefCollectionViewCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Pref.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier(at: indexPath), for: indexPath) as! PrefCollectionViewCell
        cell.delegate = self
        cell.pref = Pref.items[indexPath.row]
        return cell
    }
    
    func prefCollectionViewCell(_ cell: PrefCollectionViewCell, didSelectPref pref: Pref) {
        notifyChangeBackground(pref: pref)
        navigation?.push(AreaViewController.create(pref: pref))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isLargeCell(at: indexPath) {
            return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 2)
        } else {
            return CGSize(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.width / 4)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    private func cellIdentifier(at indexPath: IndexPath) -> String {
        return isLargeCell(at: indexPath) ? "large" : "small"
    }
    
    private func isLargeCell(at indexPath: IndexPath) -> Bool {
        return indexPath.row < 2
    }
}

protocol PrefCollectionViewCellDelegate: class {
    
    func prefCollectionViewCell(_ cell: PrefCollectionViewCell, didSelectPref pref: Pref)
}

class PrefCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var prefButton: UIButton!
    @IBOutlet private weak var japaneseLabel: UILabel!
    @IBOutlet private weak var englishLabel: UILabel!
    
    weak var delegate: PrefCollectionViewCellDelegate!
    
    var pref: Pref! {
        didSet {
            prefButton.setImage(pref.buttonImage, for: .normal)
            japaneseLabel.text = pref.japanese
            englishLabel.text = pref.rawValue.capitalized
        }
    }
    
    @IBAction private func didTapPrefButton() {
        delegate.prefCollectionViewCell(self, didSelectPref: pref)
    }
}
