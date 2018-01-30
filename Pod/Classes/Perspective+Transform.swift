//
//  Quadrilateral+Transform.swift
//  Pods
//
//  Created by Paul Zabelin on 2/20/16.
//
//

public extension Perspective {
    public convenience init(_ topLeft:CGPoint, _ topRight:CGPoint, _ bottomLeft:CGPoint, _ bottomRight:CGPoint) {
        self.init(Quadrilateral(topLeft, topRight, bottomLeft, bottomRight))
    }
    public convenience init(_ points:[CGPoint]) {
        self.init(Quadrilateral(points))
    }
    public convenience init(_ rect:CGRect) {
        self.init(Quadrilateral(rect))
    }

    public func projectiveTransform(destination:Perspective) -> CATransform3D {
        return CATransform3D(projection(to: destination).to3d())
    }
}
