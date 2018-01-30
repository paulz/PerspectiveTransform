//
//  Quadrilateral.swift
//  Pods
//
//  Created by Paul Zabelin on 2/20/16.
//
//

import CoreGraphics

public final class Quadrilateral {
    public var corners : [CGPoint] {
        return [topLeft, topRight, bottomLeft, bottomRight]
    }
    
    private let topLeft: CGPoint
    private let topRight: CGPoint
    private let bottomLeft: CGPoint
    private let bottomRight: CGPoint

    public init(_ topLeft:CGPoint, _ topRight:CGPoint, _ bottomLeft:CGPoint, _ bottomRight:CGPoint) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }

    public convenience init(_ points:[CGPoint]) {
        assert(points.count == 4, "exactly 4 corners required")
        self.init(points[0], points[1], points[2], points[3])
    }

    public convenience init(_ origin:CGPoint, _ size:CGSize) {
        let stayPut = CGAffineTransform.identity
        let shiftRight = CGAffineTransform(translationX: size.width, y: 0)
        let shiftDown = CGAffineTransform(translationX: 0, y: size.height)
        let shiftRightAndDown = shiftRight.concatenating(shiftDown)
        let originToCornerTransform = [
            stayPut,
            shiftRight,
            shiftDown,
            shiftRightAndDown
        ]
        self.init(originToCornerTransform.map{origin.applying($0)})
    }

    public convenience init(_ rect:CGRect) {
        self.init(rect.origin, rect.size)
    }
}
