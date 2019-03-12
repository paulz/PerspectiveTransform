//
//  CATransform3D+MatrixPerformanceTest.swift
//  Framework Unit Specs
//
//  Created by Paul Zabelin on 3/12/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import simd
@testable import PerspectiveTransform

class CATransform3DMatrixPerformanceTest: XCTestCase {
    let m4x4 = double4x4((1...4).map { row in
        double4((1...4).map {Double(10 * row + $0)})
    })
    let iterations = 100000

    /// Shows that bitcast is 2-5 times faster
    func testInitUsingBitcast() {
        measure {
            for _ in (0...iterations) {
                _ = CATransform3D(m4x4)
            }
        }
    }

    /// Shows that designated init is slower
    func testInitUsingDesignatedInitializer() {
        measure {
            for _ in (0...iterations) {
                _ = CATransform3D(
                    m11: CGFloat(m4x4[0, 0]), m12: CGFloat(m4x4[0, 1]), m13: CGFloat(m4x4[0, 2]), m14: CGFloat(m4x4[0, 3]),
                    m21: CGFloat(m4x4[1, 0]), m22: CGFloat(m4x4[1, 1]), m23: CGFloat(m4x4[1, 2]), m24: CGFloat(m4x4[1, 3]),
                    m31: CGFloat(m4x4[2, 0]), m32: CGFloat(m4x4[2, 1]), m33: CGFloat(m4x4[2, 2]), m34: CGFloat(m4x4[2, 3]),
                    m41: CGFloat(m4x4[3, 0]), m42: CGFloat(m4x4[3, 1]), m43: CGFloat(m4x4[3, 2]), m44: CGFloat(m4x4[3, 3])
                )
            }
        }
    }
}
