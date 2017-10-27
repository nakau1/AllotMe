// *****************************************************************************
// AllotMe
// (c) NAKAYASU Yuichi all rights reserves.
// *****************************************************************************
import SWXMLHash

extension XMLIndexer {
    
    var string: String? {
        return element?.text
    }
    
    var stringFilledValue: String? {
        guard let ret = element?.text, !ret.isEmpty else {
            return nil
        }
        return ret
    }
    
    var stringValue: String {
        return string ?? ""
    }
    
    var joinedString: String? {
        return element?.children.flatMap { content -> String? in
            return (content as? TextElement)?.text
        }.joined()
    }
    
    var joinedStringValue: String {
        return joinedString ?? ""
    }
    
    var int: Int? {
        if let text = element?.text {
            return Int(text)
        }
        return nil
    }
    
    var intValue: Int {
        return int ?? 0
    }
    
    var double: Double? {
        if let text = element?.text {
            return Double(text)
        }
        return nil
    }
    
    var doubleValue: Double {
        return double ?? 0
    }
    
    func joinedString(keys: [String], separator: String = "") -> String {
        return keys.flatMap {
            return self[$0].string
        }.joined(separator: separator)
    }
}
