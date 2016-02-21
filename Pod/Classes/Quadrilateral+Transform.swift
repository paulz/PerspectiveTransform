//
//  Quadrilateral+Transform.swift
//  Pods
//
//  Created by Paul Zabelin on 2/20/16.
//
//

import UIKit
import simd

public extension Quadrilateral {
    internal func basisVectorsToPointsMap() -> Matrix3x3Type {
        let m = Matrix3x3Type([
            p1.homogeneous3dvector,
            p2.homogeneous3dvector,
            p3.homogeneous3dvector]
        )
        let v = m.inverse * p4.homogeneous3dvector
        let diag = Matrix3x3Type(diagonal: v)
        let result = m * diag
        return result.zNormalized()
    }

    internal func general2DProjection(to:Quadrilateral) -> Matrix3x3Type {
        let source = basisVectorsToPointsMap()
        let destination = to.basisVectorsToPointsMap()
        let result = destination * source.inverse
        return result.zNormalized()
    }

    public func projectiveTransform(quad:Quadrilateral) -> CATransform3D {
        let projection = general2DProjection(quad)
        print(projection)
        return CATransform3D(projection.to3d())
    }
}
