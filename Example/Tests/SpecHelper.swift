//
//  SpecHelper.swift
//  PerspectiveTransform
//
//  Created by Paul Zabelin on 2/19/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import simd

public func ==(lhs: float2x2, rhs: float2x2) -> Bool {
    return matrix_equal(lhs.cmatrix, rhs.cmatrix)
}
extension float2x2 : Equatable {}

public func ==(lhs: float3x3, rhs: float3x3) -> Bool {
    return matrix_equal(lhs.cmatrix, rhs.cmatrix)
}
extension float3x3 : Equatable {}


