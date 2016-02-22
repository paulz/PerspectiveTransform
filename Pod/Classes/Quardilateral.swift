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
        corners = points
    }
    public convenience init(_ origin:CGPoint, _ size:CGSize) {
        self.init([
            origin,
            CGPointApplyAffineTransform(origin, CGAffineTransformMakeTranslation(size.width, 0)),
            CGPointApplyAffineTransform(origin, CGAffineTransformMakeTranslation(0, size.height)),
            CGPointApplyAffineTransform(origin, CGAffineTransformMakeTranslation(size.width, size.height)),
            ])
    }
    public convenience init(_ rect:CGRect) {
        self.init(rect.origin, rect.size)
    }
}
