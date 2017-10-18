// *****************************************************************************
// AllotMe
// (c) NAKAYASU Yuichi all rights reserves.
// *****************************************************************************
import Alamofire
import SWXMLHash

class RakutenRequest: WebAPIRequestable {
    
    struct Result {
        let page: Page
        let plans: [Plan]
    }
    
    typealias Response = Result
    
    private let condition: Condition
    
    init(condition: Condition) {
        self.condition = condition
    }
    
    var urlString: String {
        return "https://app.rakuten.co.jp/services/api/Travel/VacantHotelSearch/20170426"
    }
    
    var method: HTTPMethod { return .get }
    
    func parse(_ xml: XMLIndexer) -> Result {
        return Result(
            page: parse(page: xml["root"]["pagingInfo"]),
            plans: parse(hotels: xml["root"]["hotels"]["hotel"].all)
        )
    }
    
    private func parse(page xml: XMLIndexer) -> Page {
        var ret = Page()
        ret.total = xml["recordCount"].intValue
        ret.count = xml["pageCount"].intValue
        ret.current = xml["page"].intValue
        return ret
    }
    
    private func parse(hotels xmls: [XMLIndexer]) -> [Plan] {
        return xmls.map { xml -> Plan in
            var plan = Plan()
            parse(hoteBaselInfo: xml["hotelBasicInfo"], to: &plan)
            parse(hotelDetailInfo: xml["hotelDetailInfo"], to: &plan)
            parse(roomBaseInfo: xml["roomInfo"]["roomBasicInfo"], to: &plan)
            parse(dailyCharge: xml["roomInfo"]["dailyCharge"], to: &plan)
            return plan
        }
    }
    
    private func parse(hoteBaselInfo xml: XMLIndexer, to plan: inout Plan) {
        plan.hotelID = xml["hotelNo"].stringValue
        plan.hotelName = xml["hotelName"].stringValue
        plan.hotelNameKana = xml["hotelKanaName"].stringValue
        plan.hotelURL = xml["hotelInformationUrl"].stringValue
        plan.hotelSummery = xml["hotelSpecial"].stringValue
        
        plan.postalCode = "〒\(xml["postalCode"].stringValue)"
        plan.address = xml.joinedString(keys: ["address1", "address2"])
        plan.access = xml["access"].string
        plan.parking = xml["parkingInformation"].string
        
        plan.tel = xml["telephoneNo"].stringValue
        
        plan.thumbURLString = xml["hotelThumbnailUrl"].stringValue
        plan.imageURLString = xml["hotelImageUrl"].stringValue
        plan.imageURLStrings = [
            xml["hotelImageUrl"].string,
            xml["roomImageUrl"].string,
            xml["hotelMapImageUrl"].string,
        ].flatMap { $0 }
        
        plan.ratingCount = xml["reviewCount"].intValue
        plan.rate = xml["reviewAverage"].double
        
        let lat = xml["latitude"].doubleValue
        let lng = xml["longitude"].doubleValue
        plan.latitude = lat.latitudeTDtoWGS(longitude: lng)
        plan.longitude = lng.longitudeTDtoWGS(latitude: lat)
    }
    
    private func parse(hotelDetailInfo xml: XMLIndexer, to plan: inout Plan) {
        plan.checkIn = xml["checkinTime"].stringValue
        plan.checkOut = xml["checkoutTime"].stringValue
        plan.lastCheckIn = xml["lastCheckinTime"].stringValue
        plan.reservationTel = xml["reserveTelephoneNo"].stringValue
    }
    
    private func parse(roomBaseInfo xml: XMLIndexer, to plan: inout Plan) {
        plan.planName = xml.joinedString(keys: ["planName", "roomName"], separator: "\n")
        plan.summery = xml["planContents"].joinedStringValue
        plan.planURL = xml["reserveUrl"].stringValue
    }
    
    private func parse(dailyCharge xml: XMLIndexer, to plan: inout Plan) {
        plan.price = xml["total"].intValue
    }
    
    var parameters: [String : Any]? {
        let ret: [String : Any] = [
            "applicationId": "1075504390658522321",
            "affiliateId": "161af580.0c42f208.161af581.a3474b7e",
            "format": "xml",
            "formatVersion": "2",
            "adultNum": "1",
            "sort": "+roomCharge",
            "searchPattern": "1",
            "responseType": "large",
            
            "latitude": "\(condition.area.latitude.latitudeWGStoTD(longitude: condition.area.longitude))",
            "longitude": "\(condition.area.longitude.longitudeWGStoTD(latitude: condition.area.latitude))",
            "searchRadius": "\(condition.area.radius)",
            "checkinDate":"2017-12-01",
            "checkoutDate":"2017-12-02",
        ]
        return ret
    }
}
