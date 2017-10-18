// *****************************************************************************
// AllotMe
// (c) NAKAYASU Yuichi all rights reserves.
// *****************************************************************************
import UIKit

enum Pref: String {
    case sapporo
    case sendai
    case tokyo
    case yokohama
    case nagoya
    case osaka
    case kyoto
    case kobe
    case hiroshima
    case fukuoka
    
    var japanese: String {
        switch self {
        case .sapporo:   return "札幌"
        case .sendai:    return "仙台"
        case .tokyo:     return "東京"
        case .yokohama:  return "横浜"
        case .nagoya:    return "名古屋"
        case .osaka:     return "大阪"
        case .kyoto:     return "京都"
        case .kobe:      return "神戸"
        case .hiroshima: return "広島"
        case .fukuoka:   return "福岡"
        }
    }
    
    var backgroundImage: UIImage {
        return UIImage(named: "bg-\(rawValue)")!
    }
    
    var buttonImage: UIImage {
        return UIImage(named: "btn-\(rawValue)")!
    }
    
    static var defaultBackgroundImage: UIImage {
        return UIImage(named: "bg-default")!
    }
    
    static var items: [Pref] {
        return [.tokyo, .osaka, .nagoya, .fukuoka, .sapporo, .yokohama, .kyoto, .sendai, .kobe, .hiroshima]
    }
}
