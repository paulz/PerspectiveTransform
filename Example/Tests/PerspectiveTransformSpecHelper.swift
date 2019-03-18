//
//  PerspectiveTransformSpecHelper.swift
//  PerspectiveTransform
//
//  Created by Paul Zabelin on 2/28/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import GameKit
import Nimble

@testable import PerspectiveTransform

func beCloseTo(_ expectedValue: Matrix3x3, within delta: Double = 0.00001) -> Predicate<Matrix3x3> {
    return Predicate<Matrix3x3> { actualExpression in
        let actualValue = try! actualExpression.evaluate()!
        return PredicateResult(
            bool: simd_almost_equal_elements(actualValue, expectedValue, Scalar(delta)),
            message: ExpectationMessage.expectedActualValueTo("be close to \(expectedValue)")
        )
    }
}

func beCloseTo(_ expectedValue: Vector3, within delta: Double = 0.00001) -> Predicate<Vector3> {
    return Predicate<Vector3> { actualExpression in
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

public func beCloseTo(_ expectedValues: [Vector3], within delta: Double = DefaultDelta) -> Predicate<[Vector3]> {
    let errorMessage = "be close to <\(stringify(expectedValues))> (each within \(stringify(delta)))"
    return Predicate.simple(errorMessage) { actualExpression in
        if let actual = try actualExpression.evaluate() {
            if actual.count != expectedValues.count {
                return .doesNotMatch
            } else {
                for (index, actualItem) in actual.enumerated() {
                    let singleExpression = Expression(expression: {actualItem}, location: actualExpression.location)
                    if try! beCloseTo(expectedValues[index]).satisfies(singleExpression).toBoolean(expectation: ExpectationStyle.toMatch) == false {
                        return .doesNotMatch
                    }
                }
                return .matches
            }
        }
        return .doesNotMatch
    }
}

public func ≈(lhs: Expectation<Matrix3x3>, rhs: Matrix3x3) {
    lhs.to(beCloseTo(rhs))
}

public func ≈(lhs: Expectation<Matrix3x3>, rhs: (expected: Matrix3x3, delta: Double)) {
    lhs.to(beCloseTo(rhs.expected, within: rhs.delta))
}

public func ≈(lhs: Expectation<Vector3>, rhs: Vector3) {
    lhs.to(beCloseTo(rhs))
}

public func ≈(lhs: Expectation<Vector3>, rhs: (expected: Vector3, delta: Double)) {
    lhs.to(beCloseTo(rhs.expected, within: rhs.delta))
}

public func ≈(lhs: Expectation<[Vector3]>, rhs: [Vector3]) {
    lhs.to(beCloseTo(rhs))
}

public func ≈(lhs: Expectation<[Vector3]>, rhs: (expected: [Vector3], delta: Double)) {
    lhs.to(beCloseTo(rhs.expected, within: rhs.delta))
}

extension Matrix3x3 {
    init(_ array: [Scalar]) {
        let rows = 3
        let scalars = rows * rows
        precondition(array.count == scalars, "should have 9 values for 3x3 matrix")
        var rowsOfVectors: [Vector3] = []
        for index in stride(from: 0, to: scalars, by: rows) {
            let rowSlice = array[index...index + rows - 1]
            rowsOfVectors.append(Vector3(Array(rowSlice)))
        }
        self.init(rows: rowsOfVectors)
    }
}

extension CATransform3D {
    func layerRotation() -> Vector3 {
        let layer = CALayer()
        layer.transform = self

        var rotate = Vector3()
        rotate.x = layer.value(forKeyPath: "transform.rotation.x") as! Double
        rotate.y = layer.value(forKeyPath: "transform.rotation.y") as! Double
        rotate.z = layer.value(forKeyPath: "transform.rotation.z") as! Double
        return rotate
    }
}

extension Vector3 {
    var dehomogenized: CGPoint {return CGPoint(x: z.isZero ? 0 : x/z, y: z.isZero ? 0 : y/z)}
}

func arrayWith<S>(_ factory: (() -> S)) -> [S] {
    return Array(Vector3.indexSlice).map {_ in factory()}
}

extension GKRandomSource {
    func nextVector() -> Vector3 {
        return Vector3(arrayWith(nextDouble))
    }
    func nextMatrix() -> Matrix3x3 {
        return Matrix3x3(arrayWith(nextVector))
    }
}
