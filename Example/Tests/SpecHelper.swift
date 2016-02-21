//
//  SpecHelper.swift
//  PerspectiveTransform
//
//  Created by Paul Zabelin on 2/19/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import simd
import Nimble

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

public func ==(lhs: float4, rhs: float4) -> Bool {
  return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z && lhs.w == rhs.w
}
extension float4 : Equatable {}

public func beCloseTo(expectedValue: float3x3, within delta: Double = 0.00001) -> NonNilMatcherFunc<float3x3> {
  return NonNilMatcherFunc<float3x3> { (actualExpression:Expression<float3x3>, failureMessage:FailureMessage) in
    return matrix_almost_equal_elements(try! actualExpression.evaluate()!.cmatrix, expectedValue.cmatrix, Float(delta))
  }
}

public func ≈(lhs: Expectation<float3x3>, rhs: float3x3) {
  lhs.to(beCloseTo(rhs))
}

public func ≈(lhs: Expectation<float3x3>, rhs: (expected: float3x3, delta: Double)) {
  lhs.to(beCloseTo(rhs.expected, within: rhs.delta))
}

public func ±(lhs: float3x3, rhs: Double) -> (expected: float3x3, delta: Double) {
  return (expected: lhs, delta: rhs)
}

extension float3x3 {
    init(_ array:[Float]) {
        let row1 = float3(Array(array[0...2]))
        let row2 = float3(Array(array[3...5]))
        let row3 = float3(Array(array[6...8]))
        let rows = [row1, row2, row3]
        self.init(rows: rows)
    }

    func toA() -> [Float] {
        let t = transpose
        return t[0].toA() + t[1].toA() + t[2].toA()
    }
}

extension float4 {
    func toA() -> [Float] {
        return [x,y,z,w]
    }
}

extension float4x4 {
    func toA() -> [Float] {
        let t = transpose
        return t[0].toA() + t[1].toA() + t[2].toA() + t[3].toA()
    }
    func toAA() -> [[Float]] {
        let t = transpose
        return [t[0].toA(), t[1].toA(), t[2].toA(), t[3].toA()]
    }
}


extension float3 {
    func toA() -> [Float] {
        return [x, y, z]
    }
}

