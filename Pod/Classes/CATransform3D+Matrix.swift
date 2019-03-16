//
//  CATransform3D+float4x4.swift
//  Pods
//
//  Created by Paul Zabelin on 2/21/16.
//
//

import QuartzCore

extension CATransform3D {
    init(_ matrix: Matrix4x4) {
        self = unsafeBitCast(matrix, to: CATransform3D.self)
    }
}
