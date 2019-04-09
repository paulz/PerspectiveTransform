import UIKit
import QuartzCore

public extension UIView {
    func resetAnchorPoint() {
        let rect = frame
        layer.anchorPoint = CGPoint.zero
        frame = rect
    }
}
