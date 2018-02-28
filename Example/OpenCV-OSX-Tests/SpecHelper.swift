//
//  OpenCVMacTests.swift
//  OpenCVMacTests
//
//  Created by Paul Zabelin on 2/28/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Nimble

extension CATransform3D {
    func flattened() -> [CGFloat] {
        return [
            m11, m12, m13, m14,
            m21, m22, m23, m24,
            m31, m32, m33, m34,
            m41, m42, m43, m44,
        ]
    }
}

public func beCloseTo(_ expectedValue: CATransform3D, within delta: CGFloat = CGFloat(DefaultDelta)) -> Predicate<CATransform3D> {
    let errorMessage = "be close to <\(stringify(expectedValue))> (each within \(stringify(delta)))"
    return Predicate.simple(errorMessage) { actualExpression in
        if let actual = try actualExpression.evaluate() {
            if CATransform3DEqualToTransform(actual, expectedValue) {
                return .matches
            } else {
                let expected = expectedValue.flattened()
                for (index, m) in actual.flattened().enumerated() {
                    if fabs(m - expected[index]) > delta {
                        return .doesNotMatch
                    }
                }
                return .matches
            }
        }
        return .doesNotMatch
    }
}

public func ≈(lhs: Expectation<CATransform3D>, rhs: CATransform3D) {
    lhs.to(beCloseTo(rhs))
}
