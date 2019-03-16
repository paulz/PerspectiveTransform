//
//  CGGeometry+3D.swift
//  Pods
//
//  Created by Paul Zabelin on 2/21/16.
//
//

import CoreGraphics

extension CGPoint {
    var homogeneous3dvector: Vector3 {
        return .init(.init(x), .init(y), .one)
    }
}
