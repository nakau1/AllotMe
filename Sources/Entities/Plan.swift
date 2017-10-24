// *****************************************************************************
// AllotMe
// (c) NAKAYASU Yuichi all rights reserves.
// *****************************************************************************
import Foundation
import CoreLocation

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
    
    var stayDate: Date?
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
    
    var location = CLLocationCoordinate2D(latitude: 34.688986, longitude: 135.496204)
    
    var supplier = Supplier.rakuten
}
