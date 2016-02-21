//
//  CATransform3D+float3x3.swift
//  Pods
//
//  Created by Paul Zabelin on 2/21/16.
//
//

import QuartzCore
import simd

extension CATransform3D {
    static let addColumn : float4x3 =  {
        var m = float4x3(diagonal:float3(1,1,0))
        m[3,2] = 1
        return m
    }()

    static let addRow : float3x4 =  {
        var m = float3x4(diagonal:float3(1,1,0))
        m[2,3] = 1
        return m
    }()

    init(_ m: float3x3) {
        var result = CATransform3D.addRow * m * CATransform3D.addColumn
        result[2,2] = 1
        self.init(result)
    }
}
