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
            float3(p1),
            float3(p2),
            float3(p3)]
        )
        let v4 = float3(p4)
        let v = m.inverse * v4
        let diag = float3x3(diagonal: v)
        let result = m * diag
        return normalize(result)
    }

    func general2DProjection(to:Quadrilateral) -> float3x3 {
        let source = basisVector()
        let destination = to.basisVector()
        let result = destination * source.inverse
        return normalize(result)
    }

    public func projectiveTransform(quad:Quadrilateral) -> CATransform3D {
        let projection = general2DProjection(quad)
        print(projection)
        return CATransform3D(projection)
    }
}

import simd

extension float3 {
    init(_ point:CGPoint) {
        self.init(Float(point.x), Float(point.y), 1)
    }
}
func normalize(input:float3x3) -> float3x3 {
    return (Float(1) / input[2,2]) * input
}
