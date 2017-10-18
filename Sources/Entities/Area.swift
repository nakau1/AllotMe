// *****************************************************************************
// AllotMe
// (c) NAKAYASU Yuichi all rights reserves.
// *****************************************************************************
import Foundation

struct Area {
    
    let name: String
    let latitude: Double
    let longitude: Double
    let radius: Double
    
    init(_ name: String, _ latitude: Double, _ longitude: Double, _ radius: Double = 1.0) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
    }

    // 東京
    static let ikebukuro = Area("池袋", 35.7295028, 139.7109001)
    static let shinjuku = Area("新宿", 35.6894072, 139.70030580000002)
    static let shibuya = Area("渋谷駅", 35.660696, 139.699119)
    static let shinagawa = Area("品川駅周辺", 35.6284713, 139.73875969999995)
    static let tokyo = Area("東京駅/八重洲/日本橋", 35.678694, 139.773053)
    static let akihabara = Area("秋葉原", 35.698353, 139.77311429999997)
    static let ueno = Area("上野/御徒町", 35.709101, 139.774139)
    static let asakusa = Area("浅草", 35.698353, 139.77311429999997)
    // 大阪
    static let shinosaka = Area("新大阪", 34.734027, 135.500050)
    static let umeda = Area("梅田・大阪駅/福島", 34.703768, 135.493389, 1.1)
    static let honmachi = Area("肥後橋/本町/北浜", 34.687082, 135.501303)
    // 札幌
    
    // 仙台
    

    // 横浜
    
    // 名古屋

    
    // 京都
    // 神戸
    // 広島
    // 福岡
    
    /*
    池袋駅    35.7295028    139.7109001    OK
    新宿駅    35.6894072    139.70030580000002    OK
     原宿/表参道/外苑 35.669346、139.710117
    渋谷  35.660696, 139.699119   OK
    六本木駅    35.6627251    139.73121649999996    OK
    品川駅    35.6284713    139.73875969999995    OK
     赤坂/六本木 35.669197, 139.737166
     神田/小伝馬町/馬喰町 35.690371, 139.776797
    東京駅/八重洲/日本橋 35.678694, 139.773053  OK
    秋葉原    35.698353, 139.77311429999997    OK
     神保町 35.695892, 139.759613
    上野/御徒町  35.709101, 139.774139    OK
    浅草    35.712173, 139.794718    OK
    浜松町/大門/芝公園 35.655785, 139.752785
    新橋 35.666982, 139.755436
     錦糸町 35.666982, 139.755436
    */
    
    static func items(of pref: Pref) -> [Area] {
        switch pref {
        case .sapporo:
            return []
        case .sendai:
            return []
        case .tokyo:
            return [ikebukuro, shinjuku, shibuya, shinagawa, tokyo, akihabara, ueno, asakusa]
        case .yokohama:
            return []
        case .nagoya:
            return []
        case .osaka:
            return [shinosaka, umeda, honmachi]
        case .kyoto:
            return []
        case .kobe:
            return []
        case .hiroshima:
            return []
        case .fukuoka:
            return []
        }
    }
}
