#if os(iOS)
import UIKit
#endif

public class QuadrilateralCalc {
    public init() {}

    public var topLeft = CGPoint.zero
    public var topRight = CGPoint.zero
    public var bottomLeft = CGPoint.zero
    public var bottomRight = CGPoint.zero

    public func box() -> CGRect {
        let xmin = min(min(min(topRight.x, topLeft.x), bottomLeft.x), bottomRight.x)
        let ymin = min(min(min(topRight.y, topLeft.y), bottomLeft.y), bottomRight.y)
        let xmax = max(max(max(topRight.x, topLeft.x), bottomLeft.x), bottomRight.x)
        let ymax = max(max(max(topRight.y, topLeft.y), bottomLeft.y), bottomRight.y)
        return CGRect(origin: CGPoint(x: xmin, y: ymin), size: CGSize(width: xmax - xmin, height: ymax - ymin))
    }

    public func modifyPoints(transform:(CGPoint)->CGPoint) {
        topLeft = transform(topLeft)
        topRight = transform(topRight)
        bottomLeft = transform(bottomLeft)
        bottomRight = transform(bottomRight)
    }

    public func transformToFit(bounds: CGRect, anchorPoint: CGPoint) -> CATransform3D {
        let boundingBox = box()
        let frameTopLeft = boundingBox.origin

        let quad = QuadrilateralCalc()
        quad.topLeft = CGPoint(x: topLeft.x-frameTopLeft.x, y: topLeft.y-frameTopLeft.y)
        quad.topRight = CGPoint(x: topRight.x-frameTopLeft.x, y: topRight.y-frameTopLeft.y)
        quad.bottomLeft = CGPoint(x: bottomLeft.x-frameTopLeft.x, y: bottomLeft.y-frameTopLeft.y)
        quad.bottomRight = CGPoint(x: bottomRight.x-frameTopLeft.x, y: bottomRight.y-frameTopLeft.y)

        let transform = rectToQuad(rect: bounds, quad: quad)

        let anchorOffset = CGPoint(x: anchorPoint.x - boundingBox.origin.x, y: anchorPoint.y - boundingBox.origin.y)

        let transPos = CATransform3DMakeTranslation(anchorOffset.x, anchorOffset.y, 0)
        let transNeg = CATransform3DMakeTranslation(-anchorOffset.x, -anchorOffset.y, 0)
        let fullTransform = CATransform3DConcat(CATransform3DConcat(transPos, transform), transNeg)

        return fullTransform
    }

    public func rectToQuad(rect: CGRect, quad: QuadrilateralCalc) -> CATransform3D {
        let x1a = quad.topLeft.x
        let y1a = quad.topLeft.y
        let x2a = quad.topRight.x
        let y2a = quad.topRight.y
        let x3a = quad.bottomLeft.x
        let y3a = quad.bottomLeft.y
        let x4a = quad.bottomRight.x
        let y4a = quad.bottomRight.y

        let X = rect.origin.x
        let Y = rect.origin.y
        let W = rect.size.width
        let H = rect.size.height

        let y21 = y2a - y1a
        let y32 = y3a - y2a
        let y43 = y4a - y3a
        let y14 = y1a - y4a
        let y31 = y3a - y1a
        let y42 = y4a - y2a

        let a = -H*(x2a*x3a*y14 + x2a*x4a*y31 - x1a*x4a*y32 + x1a*x3a*y42)
        let b = W*(x2a*x3a*y14 + x3a*x4a*y21 + x1a*x4a*y32 + x1a*x2a*y43)
        let c = H*X*(x2a*x3a*y14 + x2a*x4a*y31 - x1a*x4a*y32 + x1a*x3a*y42) - H*W*x1a*(x4a*y32 - x3a*y42 + x2a*y43) - W*Y*(x2a*x3a*y14 + x3a*x4a*y21 + x1a*x4a*y32 + x1a*x2a*y43)

        let d = H*(-x4a*y21*y3a + x2a*y1a*y43 - x1a*y2a*y43 - x3a*y1a*y4a + x3a*y2a*y4a)
        let e = W*(x4a*y2a*y31 - x3a*y1a*y42 - x2a*y31*y4a + x1a*y3a*y42)
        let f1 = (x4a*(Y*y2a*y31 + H*y1a*y32) - x3a*(H + Y)*y1a*y42 + H*x2a*y1a*y43 + x2a*Y*(y1a - y3a)*y4a + x1a*Y*y3a*(-y2a + y4a))
        let f2 = x4a*y21*y3a - x2a*y1a*y43 + x3a*(y1a - y2a)*y4a + x1a*y2a*(-y3a + y4a)
        let f = -(W*f1 - H*X*f2)

        let g = H*(x3a*y21 - x4a*y21 + (-x1a + x2a)*y43)
        let h = W*(-x2a*y31 + x4a*y31 + (x1a - x3a)*y42)

        let temp = X * (-x3a*y21 + x4a*y21 + x1a*y43 - x2a*y43) + W * (-x3a*y2a + x4a*y2a + x2a*y3a - x4a*y3a - x2a*y4a + x3a*y4a)
        var i = W * Y * (x2a*y31 - x4a*y31 - x1a*y42 + x3a*y42) + H * temp

        let kEpsilon = CGFloat(0.0001)

        if abs(i) < kEpsilon {
            i = kEpsilon * (i > 0 ? 1.0 : -1.0);
        }

        return CATransform3D(m11:a/i, m12:d/i, m13:0, m14:g/i,
                             m21:b/i, m22:e/i, m23:0, m24:h/i,
                             m31:0, m32:0, m33:1, m34:0,
                             m41:c/i, m42:f/i, m43:0, m44:1.0)
    }

}
