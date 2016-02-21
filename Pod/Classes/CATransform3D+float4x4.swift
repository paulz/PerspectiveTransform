//
//  CATransform3D+float4x4.swift
//  Pods
//
//  Created by Paul Zabelin on 2/21/16.
//
//

import QuartzCore
import simd

extension CATransform3D {
    init(_ m: float4x4) {
        self.init(
            m11: CGFloat(m[0,0]), m12: CGFloat(m[0,1]), m13: CGFloat(m[0,2]), m14: CGFloat(m[0,3]),
            m21: CGFloat(m[1,0]), m22: CGFloat(m[1,1]), m23: CGFloat(m[1,2]), m24: CGFloat(m[1,3]),
            m31: CGFloat(m[2,0]), m32: CGFloat(m[2,1]), m33: CGFloat(m[2,2]), m34: CGFloat(m[2,3]),
            m41: CGFloat(m[3,0]), m42: CGFloat(m[3,1]), m43: CGFloat(m[3,2]), m44: CGFloat(m[3,3])
        )
    }
}
