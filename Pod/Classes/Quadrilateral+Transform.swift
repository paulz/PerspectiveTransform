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
    func basisVector() -> float3x3 {
        let m = float3x3([
            p1.vector3d,
            p2.vector3d,
            p3.vector3d]
        )
        let v = m.inverse * p4.vector3d
        let diag = float3x3(diagonal: v)
        let result = m * diag
        return result.zNormalized()
    }

    func general2DProjection(to:Quadrilateral) -> float3x3 {
        let source = basisVector()
        let destination = to.basisVector()
        let result = destination * source.inverse
        return result.zNormalized()
    }

    public func projectiveTransform(quad:Quadrilateral) -> CATransform3D {
        let projection = general2DProjection(quad)
        print(projection)
        return CATransform3D(projection)
    }
}

extension CGPoint {
    var vector3d : float3 {
        return float3(Float(x), Float(y), 1)
    }
}

extension float3x3 {
    func zNormalized() -> float3x3 {
        return (Float(1) / self[2,2]) * self
    }
}
