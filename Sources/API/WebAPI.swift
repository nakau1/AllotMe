// *****************************************************************************
// AllotMe
// (c) NAKAYASU Yuichi all rights reserves.
// *****************************************************************************
import Alamofire
import SWXMLHash

class WebAPI {
    
    class func request<T: WebAPIRequestable>(_ requestable: T, responsedHandler: @escaping (T.Response?, WebAPIResult) -> Void) {
        
        let request = Alamofire.request(
            requestable.urlString,
            method: requestable.method,
            parameters: requestable.parameters ?? [:],
            encoding: URLEncoding.default,
            headers: nil
        )
        
        request.validate().response { dataResponse in
            var result = WebAPIResult()
            result.statusCode = dataResponse.response?.statusCode ?? 0
            result.requestedURL = dataResponse.request?.url?.absoluteString ?? ""
            
            if let error = dataResponse.error {
                result.error = error
                responsedHandler(nil, result)
                return
            }
            guard let data = dataResponse.data else {
                result.error = WebAPIError.nodata
                responsedHandler(nil, result)
                return
            }
            
            let xml = SWXMLHash.parse(data)
            responsedHandler(requestable.parse(xml), result)
        }
    }
}

protocol WebAPIRequestable {
    
    associatedtype Response
    
    var urlString: String { get }
    
    func parse(_ xml: XMLIndexer) -> Response
    
    var method: Alamofire.HTTPMethod { get }
    
    var parameters: [String : Any]? { get }
}

struct WebAPIResult {
    
    var error: Error?
    
    var statusCode: Int = 0
    
    var requestedURL = ""
    
    var ok: Bool {
        return self.error == nil
    }
}

enum WebAPIError: Error {
    case nodata
    case parse
    
    var localizedDescription: String {
        switch self {
        case .nodata: return "responsed no data"
        case .parse: return "cannot parse to xml by responsed data"
        }
    }
}

extension Alamofire.DataRequest {
    
    var curlDescription: String {
        var ret = self.debugDescription
        for char in ["$ ", "\t"] {
            ret = ret.replacingOccurrences(of: char, with: "")
        }
        return ret
    }
}
