import UIKit

public extension UIView {
    public func resetAnchorPoint() {
        let rect = frame
        layer.anchorPoint = CGPoint.zero
        frame = rect
    }
}
