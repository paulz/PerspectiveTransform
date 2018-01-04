//
//  SpecHelper.swift
//  PerspectiveTransform
//
//  Created by Paul Zabelin on 2/19/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import simd
import Nimble
@testable import PerspectiveTransform


public func ==(lhs: float2x2, rhs: float2x2) -> Bool {
    return matrix_equal(lhs, rhs)
//    return matrix_almost_equal_elements(lhs.cmatrix, rhs.cmatrix, 0.001)
}
extension float2x2 : Equatable {}

func beCloseTo(_ expectedValue: Matrix3x3Type, within delta: Double = 0.00001) -> NonNilMatcherFunc<Matrix3x3Type> {
  return NonNilMatcherFunc<Matrix3x3Type> { (actualExpression:Expression<Matrix3x3Type>, failureMessage:FailureMessage) in
    let actualValue = try! actualExpression.evaluate()!.cmatrix
    failureMessage.actualValue = "\(actualValue)"
    failureMessage.expected = "\(expectedValue.cmatrix)"
    failureMessage.to = "be close"
    return matrix_equal(actualValue, expectedValue.cmatrix)
//    return matrix_almost_equal_elements(actualValue, expectedValue.cmatrix, ScalarType(delta))
  }
}

func equal(expectedValue: Vector3Type) -> NonNilMatcherFunc<Vector3Type> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        let lhs = try! actualExpression.evaluate()!
        let rhs = expectedValue
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
}

func equal(expectedValue: Matrix3x3Type) -> NonNilMatcherFunc<Matrix3x3Type> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        return matrix_equal(try! actualExpression.evaluate()!.cmatrix, expectedValue.cmatrix)
    }
}

extension Matrix3x3Type {
    init(_ array:[ScalarType]) {
        let row1 = Vector3Type(Array(array[0...2]))
        let row2 = Vector3Type(Array(array[3...5]))
        let row3 = Vector3Type(Array(array[6...8]))
        let rows = [row1, row2, row3]
        self.init(rows: rows)
    }
}
