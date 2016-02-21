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
    init(_ m: float3x3) {
        var addColumn = float4x3()
        addColumn[0,0] = 1
        addColumn[1,1] = 1
        addColumn[3,2] = 1

        var addRow = float3x4()
        addRow[0,0] = 1
        addRow[1,1] = 1
        addRow[2,3] = 1

        var result = addRow * m * addColumn

        result[2,2] = 1

        self.init(result)
    }
}
