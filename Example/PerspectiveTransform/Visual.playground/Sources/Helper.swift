import UIKit

public extension UIView {
    public func resetAnchorPoint() {
        let rect = frame
        layer.anchorPoint = CGPointZero
        frame = rect
    }
}
