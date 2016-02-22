//
//  Quadrilateral+Transform.swift
//  Pods
//
//  Created by Paul Zabelin on 2/20/16.
//
//

public extension Perspective {

    public convenience init(points:[CGPoint]) {
        self.init(Quadrilateral(points))
    }

    public convenience init(rect:CGRect) {
        self.init(Quadrilateral(rect))
    }

    public func projectiveTransform(destination:Perspective) -> CATransform3D {
        return CATransform3D(projection(destination).to3d())
    }
}
