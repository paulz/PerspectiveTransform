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
    let repeatTimes = {OpenCVPerformanceTest.reasonableTestDurationMs * 1000}()

    let destination = Quadrilateral(upperLeft: CGPoint(x: 108.315837, y: 80.1687782),
                                    upperRight: CGPoint(x: 377.282671, y: 41.4352201),
                                    lowerRight: CGPoint(x: 193.321418, y: 330.023027),
                                    lowerLeft: CGPoint(x: 459.781253, y: 251.836131))
    let start: Quadrilateral = {
        var one = Quadrilateral()
        let overlayFrame = CGRect(x: 0, y: 0, width: 1, height: 1)
        one.upperLeft = CGPoint(x: overlayFrame.minX, y: overlayFrame.minY)
        one.upperRight = CGPoint(x: overlayFrame.maxX, y: overlayFrame.minY)
        one.lowerLeft = CGPoint(x: overlayFrame.minX, y: overlayFrame.maxY)
        one.lowerRight = CGPoint(x: overlayFrame.maxX, y: overlayFrame.maxY)
        return one
    }()

    func XtestPerspectiveTransformPerformance() {
        measure {
            (self.repeatTimes/15).times {
                _ = OpenCVWrapper.perspectiveTransform(start, to: destination)
            }
        }
    }

    func testFindHomographyPerformance() {
        measure {
            (self.repeatTimes/20).times {
                _ = OpenCVWrapper.findHomography(from: start, to: destination)
            }
        }
    }
}
