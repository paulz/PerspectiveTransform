//
//  Quadrilateral.swift
//  Pods
//
//  Created by Paul Zabelin on 2/20/16.
//
//

import CoreGraphics

public final class Quadrilateral {
    public let corners : [CGPoint]

    public init(_ points:[CGPoint]) {
        assert(points.count == 4, "exactly 4 corners required")
        corners = points
    }
    public convenience init(_ origin:CGPoint, _ size:CGSize) {
        let topLeft = CGAffineTransform.identity
        let topRight = CGAffineTransform(translationX: size.width, y: 0)
        let bottomLeft = CGAffineTransform(translationX: 0, y: size.height)
        let bottomRight = CGAffineTransform(translationX: size.width, y: size.height)
        let transforms = [
            topLeft,
            topRight,
            bottomLeft,
            bottomRight
        ]
        self.init(transforms.map{origin.applying($0)})
    }
    public convenience init(_ rect:CGRect) {
        self.init(rect.origin, rect.size)
    }
}
