//
//  SpecHelper.swift
//  PerspectiveTransform
//
//  Created by Paul Zabelin on 2/19/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import simd
import GameKit
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

func beCloseTo(_ expectedValue: Vector3Type, within delta: Double = 0.00001) -> Predicate<Vector3Type> {
    return Predicate<Vector3Type> { actualExpression in
        let actualValue = try! actualExpression.evaluate()!
        let isClose = (abs(actualValue.x - expectedValue.x) < delta) &&
        (abs(actualValue.y - expectedValue.y) < delta) &&
        (abs(actualValue.z - expectedValue.z) < delta)
        return PredicateResult(
            bool: isClose,
            message: ExpectationMessage.expectedActualValueTo("be close to \(expectedValue)")
        )
    }
}


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
public func ≈(lhs: Expectation<Matrix3x3Type>, rhs: Matrix3x3Type) {
    lhs.to(beCloseTo(rhs))
}

public func ≈(lhs: Expectation<Matrix3x3Type>, rhs: (expected: Matrix3x3Type, delta: Double)) {
    lhs.to(beCloseTo(rhs.expected, within: rhs.delta))
}

public func ≈(lhs: Expectation<Vector3Type>, rhs: Vector3Type) {
    lhs.to(beCloseTo(rhs))
}

public func ≈(lhs: Expectation<Vector3Type>, rhs: (expected: Vector3Type, delta: Double)) {
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
        let rows = 3
        let scalars = rows * rows
        precondition(array.count == scalars, "should have 9 values for 3x3 matrix")
        var rowsOfVectors: [Vector3Type] = []
        for index in stride(from: 0, to: scalars, by: rows) {
            let rowSlice = array[index...index + rows - 1]
            rowsOfVectors.append(Vector3Type(Array(rowSlice)))
        }
        self.init(rows: rowsOfVectors)
    }
}

extension CATransform3D {
    func layerRotation() -> Vector3Type {
        let layer = CALayer()
        layer.transform = self

        var rotate = Vector3Type()
        rotate.x = layer.value(forKeyPath: "transform.rotation.x") as! Double
        rotate.y = layer.value(forKeyPath: "transform.rotation.y") as! Double
        rotate.z = layer.value(forKeyPath: "transform.rotation.z") as! Double
        return rotate
    }
}

func arrayWith<S>(_ factory: (()->S)) -> [S] {
    return Array(Vector3Type.indexSlice).map{_ in factory()}
}

extension GKRandomSource {
    func nextDouble() -> Double {
        return Double(nextUniform())
    }
    func nextVector() -> Vector3Type {
        return Vector3Type(arrayWith(nextDouble))
    }
    func nextMatrix() -> Matrix3x3Type {
        return Matrix3x3Type(arrayWith(nextVector))
    }

    func nextPoint() -> CGPoint {
        return CGPoint(x: nextDouble(), y: nextDouble())
    }

    func nextQuadrilateral() -> PerspectiveTransform.Quadrilateral {
        return PerspectiveTransform.Quadrilateral(Array(0...3).map {_ in nextPoint()})
    }
}
