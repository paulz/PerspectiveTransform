//
//  Quadrilateral+Transform.swift
//  Pods
//
//  Created by Paul Zabelin on 2/20/16.
//
//

import UIKit
import simd

public extension Perspective {

    internal func projection(to:Perspective) -> Matrix3x3Type {
        return (to.basisVectorsToPointsMap * pointsToBasisVectorsMap).zNormalized()
    }

    public func projectiveTransform(destination:Perspective) -> CATransform3D {
        return CATransform3D(projection(destination).to3d())
    }
}
