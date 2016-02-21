//
//  CGGeometry+3D.swift
//  Pods
//
//  Created by Paul Zabelin on 2/21/16.
//
//

import CoreGraphics
import simd

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
