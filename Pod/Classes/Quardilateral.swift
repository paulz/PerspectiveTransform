//
//  Quadrilateral.swift
//  Pods
//
//  Created by Paul Zabelin on 2/20/16.
//
//

import UIKit

public final class Quadrilateral {
    public let corners : [CGPoint]

    public init(_ points:[CGPoint]) {
        assert(points.count == 4, "exactly 4 corners required")
        corners = points
    }
    public convenience init(_ origin:CGPoint, _ size:CGSize) {
        self.init([
            origin,
            origin.applying(CGAffineTransform(translationX: size.width, y: 0)),
            origin.applying(CGAffineTransform(translationX: 0, y: size.height)),
            origin.applying(CGAffineTransform(translationX: size.width, y: size.height)),
            ])
    }
    public convenience init(_ rect:CGRect) {
        self.init(rect.origin, rect.size)
    }
}
