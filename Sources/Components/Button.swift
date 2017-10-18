// *****************************************************************************
// AllotMe
// (c) NAKAYASU Yuichi all rights reserves.
// *****************************************************************************
import UIKit

@IBDesignable class Button: UIButton {
    
    enum Style: String {
        case blue
    }
    
    @IBInspectable var style: String = "blue" {
        didSet {
            render()
        }
    }
    
    private func render() {
        switch style(from: style) {
        case .blue:
            _ = fill(color: #colorLiteral(red: 0.2862745098, green: 0.4784313725, blue: 1, alpha: 1)).round().border(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)).textColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        }
        
    }
    
    private func style(from string: String) -> Style {
        return Style(rawValue: string) ?? .blue
    }
    
    private func round(radius: CGFloat = 5) -> Self {
        layer.cornerRadius = radius
        clipsToBounds = true
        return self
    }
    
    private func border(color: UIColor?, width: CGFloat = 2) -> Self {
        layer.borderColor = color?.cgColor
        layer.borderWidth = width
        return self
    }
    
    private func textColor(_ color: UIColor?) -> Self {
        setTitleColor(color, for: .normal)
        return self
    }
    
    private func fill(color: UIColor?) -> Self {
        UIGraphicsBeginImageContext(frame.size)
        let context = UIGraphicsGetCurrentContext()!
        let filledColor = color ?? UIColor.clear
        context.saveGState()
        context.setFillColor(filledColor.cgColor)
        context.fill(CGRect(origin: CGPoint.zero, size: frame.size))
        context.restoreGState()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        setBackgroundImage(image, for: .normal)
        return self
    }
}
