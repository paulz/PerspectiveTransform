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
        let start = Quadrilateral(CGRect(origin: CGPointZero, size: CGSize(width: 152, height: 122)))
        let destination = Quadrilateral(
            CGRect(
                origin: CGPoint(x: 100, y: 100),
                size: CGSize(width: 200, height: 200)
            )
        )

        self.measureBlock {
            0.stride(to: 100000, by: 1).forEach({ (_) -> () in
                start.projectiveTransform(destination)
            })
        }
    }

}
