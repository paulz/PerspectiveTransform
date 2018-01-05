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

func beCloseTo(_ expectedValue: Matrix3x3Type, within delta: Double = 0.00001) -> Predicate<Matrix3x3Type> {
    return Predicate<Matrix3x3Type> { actualExpression in
        let actualValue = try! actualExpression.evaluate()!
        return PredicateResult(
            bool: simd_almost_equal_elements(actualValue, expectedValue, ScalarType(delta)),
            message: ExpectationMessage.expectedActualValueTo("be close to \(expectedValue)")
        )
    }
}

public func ≈(lhs: Expectation<Matrix3x3Type>, rhs: Matrix3x3Type) {
    lhs.to(beCloseTo(rhs))
}

public func ≈(lhs: Expectation<Matrix3x3Type>, rhs: (expected: Matrix3x3Type, delta: Double)) {
    lhs.to(beCloseTo(rhs.expected, within: rhs.delta))
}

extension CATransform3D: Equatable {
    public static func ==(lhs: CATransform3D, rhs: CATransform3D) -> Bool {
        return CATransform3DEqualToTransform(lhs, rhs)
    }
}

extension Int {
    func times(block: ()->Void) {
        for _ in 1...self {
            block()
        }
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
