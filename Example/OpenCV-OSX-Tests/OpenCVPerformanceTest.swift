//
//  OpenCVPerformanceTest.swift
//  OpenCV OSX Tests
//
//  Created by Paul Zabelin on 2/28/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest

class OpenCVPerformanceTest: XCTestCase {
    static let reasonableTestDurationMs = 100
    let repeatTimes = OpenCVPerformanceTest.reasonableTestDurationMs * 1000

    let destination = Quadrilateral(upperLeft: CGPoint(x: 108.315837, y: 80.1687782),
                                    upperRight: CGPoint(x: 377.282671, y: 41.4352201),
                                    lowerRight: CGPoint(x: 193.321418, y: 330.023027),
                                    lowerLeft: CGPoint(x: 459.781253, y: 251.836131))
    let start: Quadrilateral = {
        var one = Quadrilateral()
        let corners = CGRect(x: 0, y: 0, width: 1, height: 1).corners()
        one.upperLeft = corners[0]
        one.upperRight = corners[1]
        one.lowerLeft = corners[2]
        one.lowerRight = corners[3]
        return one
    }()

    /** on average perspectiveTransform 4 times faster then findHomography
     */
    func testPerspectiveTransformPerformance() {
        measure {
            (self.repeatTimes/15).times {
                _ = OpenCVWrapper.perspectiveTransform(start, to: destination)
            }
        }
    }

    /** on average findHomography 4 times slower then perspectiveTransform
     */
    func testFindHomographyPerformance() {
        measure {
            (self.repeatTimes/60).times {
                _ = OpenCVWrapper.findHomography(from: start, to: destination)
            }
        }
    }
}
