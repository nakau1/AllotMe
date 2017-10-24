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

extension String {
    
    var half: String {
        var string = self
        let regex = try! NSRegularExpression(pattern: "[０-９ａ-ｚＡ-Ｚ　]+", options: [])
        let results = regex.matches(in: self, options: [], range: NSMakeRange(0, string.count))
        results.reversed().forEach {
            let substring = (string as NSString).substring(with: $0.range)
            let halfstring = NSMutableString(string: substring) as CFMutableString
            CFStringTransform(halfstring, nil, kCFStringTransformFullwidthHalfwidth, false)
            string = string.replacingOccurrences(of: substring, with: (halfstring as String))
        }
        return string
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

extension Date {
    
    static func date(from string: String, format: String) -> Date? {
        let tmp = Date()
        let formatter = tmp.createFormatter(dateFormat: format)
        return formatter.date(from: string)
    }
    
    var japaneseString: String {
        let formatter = createFormatter(dateFormat: "yyyy年MM月dd日")
        let i = createCalendar().component(.weekday, from: self) - 1
        return "\(formatter.string(from: self))(\(formatter.shortWeekdaySymbols[i]))"
    }
    
    var hyphenatedString: String {
        return createFormatter(dateFormat: "yyyy-MM-dd").string(from: self)
    }
    
    func date(addDay: Int) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        calendar.locale = Locale(identifier: "ja")
        
        var components = DateComponents()
        components.year   = calendar.component(.year, from: self)
        components.month  = calendar.component(.month, from: self)
        components.day    = calendar.component(.day, from: self) + addDay
        components.hour   = 0
        components.minute = 0
        components.second = 0
        
        return calendar.date(from: components)!
    }
    
    private func createFormatter(dateFormat: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = createCalendar()
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        formatter.locale = Locale(identifier: "ja")
        formatter.dateFormat = dateFormat
        return formatter
    }
    
    private func createCalendar() -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        calendar.locale = Locale(identifier: "ja")
        return calendar
    }
}

extension UIScreen {
    
    class func size(for ratio: CGFloat, padding: CGFloat = 0) -> CGSize {
        let width = main.bounds.width - padding
        let height = width * ratio
        return CGSize(width: width, height: height)
    }
}
