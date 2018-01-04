//
//  PerformanceTest.swift
//  PerspectiveTransform
//
//  Created by Paul Zabelin on 2/21/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
@testable import PerspectiveTransform

class PerformanceTest: XCTestCase {
    
    func testProjectiveTransformPerformance() {
        let start = Perspective(CGRect(origin: CGPoint.zero, size: CGSize(width: 152, height: 122)))
        let destination = Perspective(
            CGRect(
                origin: CGPoint(x: 100, y: 100),
                size: CGSize(width: 200, height: 200)
            )
        )

        self.measure {
            stride(from:0, to: 100000, by: 1).forEach { _ in
                _ = start.projectiveTransform(destination: destination)
            }
        }
    }
}
