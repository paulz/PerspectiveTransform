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
    var repeatTimes = OpenCVPerformanceTest.reasonableTestDurationMs * 1000

    func testPerformance() {
        let destination = Quadrilateral(upperLeft: CGPoint(x: 108.315837, y: 80.1687782),
                                        upperRight: CGPoint(x: 377.282671, y: 41.4352201),
                                        lowerRight: CGPoint(x: 193.321418, y: 330.023027),
                                        lowerLeft: CGPoint(x: 459.781253, y: 251.836131))
        var start = Quadrilateral()
        let overlayFrame = CGRect(x: 0, y: 0, width: 1, height: 1)
        start.upperLeft = CGPoint(x: overlayFrame.minX, y: overlayFrame.minY)
        start.upperRight = CGPoint(x: overlayFrame.maxX, y: overlayFrame.minY)
        start.lowerLeft = CGPoint(x: overlayFrame.minX, y: overlayFrame.maxY)
        start.lowerRight = CGPoint(x: overlayFrame.maxX, y: overlayFrame.maxY)

        let openCVtimesSlower = 20
        self.repeatTimes /= openCVtimesSlower

        measure {
            self.repeatTimes.times {
                _ = OpenCVWrapper.findHomography(from: start, to: destination)
            }
        }
    }
}

