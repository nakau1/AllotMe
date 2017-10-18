// *****************************************************************************
// AllotMe
// (c) NAKAYASU Yuichi all rights reserves.
// *****************************************************************************
import Foundation

struct Condition {
    
    var pref: Pref!
    var area: Area!
    
    var suppliers: [Supplier] = [.rakuten, .jalan]
    
    var checkInDate = Date()
    var checkOutDate = Date()
    
    var isNoSmoking = false // 禁煙
    var hasInternat = false // インターネット付き
    var hasPublicBath = false // 大浴場付き
    var hasHotSpring = false // 温泉付き
    var hasBreakfast = false // 朝食付き
    var hasDinner = false // 夕食付き
    
    var filterHayawari = true // 早割を除く
    var filterGakueari = true // 学割を除く
    var filterMaleOnly = false // 男性を除く
    var filterFamaleOnly = false // 女性を除く
    var filterBirthday = true // 誕生日を除く
}
