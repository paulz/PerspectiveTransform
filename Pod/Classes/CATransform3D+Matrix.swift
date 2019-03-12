//
//  CATransform3D+float4x4.swift
//  Pods
//
//  Created by Paul Zabelin on 2/21/16.
//
//

import QuartzCore

extension CATransform3D {
    init(_ m: Matrix4x4Type) {
        self = unsafeBitCast(m, to: CATransform3D.self)
    }
}
