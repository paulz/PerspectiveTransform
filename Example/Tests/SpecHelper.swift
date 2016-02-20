//
//  SpecHelper.swift
//  PerspectiveTransform
//
//  Created by Paul Zabelin on 2/19/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import simd

public func ==(lhs: float2x2, rhs: float2x2) -> Bool {
    return matrix_almost_equal_elements(lhs.cmatrix, rhs.cmatrix, 0.001)
}
extension float2x2 : Equatable {}

public func ==(lhs: float3x3, rhs: float3x3) -> Bool {
    return matrix_almost_equal_elements(lhs.cmatrix, rhs.cmatrix, 0.001)
}
extension float3x3 : Equatable {}

public func ==(lhs: float3, rhs: float3) -> Bool {
  return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}
extension float3 : Equatable {}


