import UIKit
import QuartzCore

public extension UIView {
    public func resetAnchorPoint() {
        let rect = frame
        layer.anchorPoint = CGPoint.zero
        frame = rect
    }
}

public extension CATransform3D {
    var scaleComponent: CATransform3D {
        return .init(m11: m11, m12: 0, m13: 0, m14: 0,
                     m21: 0, m22: m22, m23: 0, m24: 0,
                     m31: 0, m32: 0, m33: m33, m34: 0,
                     m41: 0, m42: 0, m43: 0, m44: m44)
    }
    var translateComponent: CATransform3D {
        return .init(m11: 1, m12: 0, m13: 0, m14: 0,
                     m21: 0, m22: 1, m23: 0, m24: 0,
                     m31: 0, m32: 0, m33: 1, m34: 0,
                     m41: m41, m42: m42, m43: m43, m44: m44)
    }
    var translateAndScale: CATransform3D {
        return .init(m11: m11, m12: 0, m13: 0, m14: 0,
                     m21: 0, m22: m22, m23: 0, m24: 0,
                     m31: 0, m32: 0, m33: m33, m34: 0,
                     m41: m41, m42: m42, m43: m43, m44: m44)
    }
    var rotateComponent: CATransform3D {
        return .init(m11: 0, m12: m12, m13: m13, m14: 0,
                     m21: m21, m22: 0, m23: m23, m24: 0,
                     m31: m31, m32: m32, m33: 1, m34: 0,
                     m41: 0, m42: 0, m43: 0, m44: 1)
    }
}
