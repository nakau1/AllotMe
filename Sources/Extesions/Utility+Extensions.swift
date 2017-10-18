// *****************************************************************************
// AllotMe
// (c) NAKAYASU Yuichi all rights reserves.
// *****************************************************************************
import UIKit

extension Int {
    
    var currencyText: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        let str = formatter.string(from: NSNumber(value: self)) ?? "-"
        return "¥ \(str)"
    }
}

extension Array {
    
    var lastIndex: Int {
        return count - 1
    }
    
    var beforeLastIndex: Int {
        return count - 2
    }
    
    var beforeLastExists: Bool {
        return count >= 2
    }
    
    var beforeLastIsFirst: Bool {
        return beforeLastIndex <= 0
    }
    
    var beforeLast: Element? {
        if beforeLastExists {
            return self[beforeLastIndex]
        }
        return nil
    }
}

extension Notification {
    
    struct InfoKey {}
}
