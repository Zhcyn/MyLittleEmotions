import Foundation
public struct SideMenuItemOptions {
    public struct Shadow {
        public var color: UIColor? = UIColor.black
        public var opacity: CGFloat = 0.3
        public var offset: CGSize = CGSize(width: -5, height: 5)
        public var radius: CGFloat = 3
        public init() { }
        public init(color: UIColor? = UIColor.black,
                    opacity: CGFloat = 0.3,
                    offset: CGSize = CGSize(width: -5, height: 5),
                    radius: CGFloat = 3) {
            self.color = color
            self.opacity = opacity
            self.offset = offset
            self.radius = radius
        }
    }
    public var shadow = Shadow()
    public var cornerRadius: CGFloat = 0.0 {
        willSet {
            if newValue < 0 {
                preconditionFailure("Invalid `cornerRadius` value: \(newValue). Must be non-negative")
            }
        }
    }
    public init() { }
}
