//
//  Quadrilateral.swift
//  Pods
//
//  Created by Paul Zabelin on 2/20/16.
//
//

import UIKit

public class Quadrilateral {
    public let p1 : CGPoint
    public let p2 : CGPoint
    public let p3 : CGPoint
    public let p4 : CGPoint
    init(_ points:[CGPoint]) {
        p1 = points[0]
        p2 = points[1]
        p3 = points[2]
        p4 = points[3]
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
