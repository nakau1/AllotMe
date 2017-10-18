// *****************************************************************************
// AllotMe
// (c) NAKAYASU Yuichi all rights reserves.
// *****************************************************************************
import Foundation

struct Plan {
    var hotelID = ""
    
    var hotelName = ""
    var hotelNameKana = ""
    var planName = ""
    
    var hotelURL = ""
    var planURL = ""
    
    var thumbURLString = ""
    var imageURLString = ""
    var imageURLStrings = [String]()
    
    var ratingCount = 0
    var rate: Double?
    var price = 0
    
    var checkIn = ""
    var checkOut = ""
    var lastCheckIn: String? // 楽天のみ
    
    var postalCode = ""
    var address = ""
    var access: String? // 楽天のみ
    var parking: String? // 楽天のみ
    
    var tel = ""
    var reservationTel: String? // 楽天のみ
    
    var hotelSummery = ""
    var summery = ""
    
    var longitude = 34.688986
    var latitude = 135.496204
    
    var supplier = Supplier.rakuten
}
