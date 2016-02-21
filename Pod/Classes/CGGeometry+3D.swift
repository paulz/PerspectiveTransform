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
    var homogeneous3dvector : float3 {
        return float3(Float(x), Float(y), 1)
    }
}

