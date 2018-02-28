//
//  OpenCVMacTests.swift
//  OpenCVMacTests
//
//  Created by Paul Zabelin on 2/28/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest

class OpenCVMacTests: XCTestCase {
    let points = [
        CGPoint(x: 108.315837, y: 80.1687782),
        CGPoint(x: 377.282671, y: 41.4352201),
        CGPoint(x: 193.321418, y: 330.023027),
        CGPoint(x: 459.781253, y: 251.836131),
        ]
    let frame = CGRect(origin: CGPoint.zero,
                       size: CGSize(width: 20, height: 10))

    func openCVTransform() -> CATransform3D {
        let start = Quadrilateral(upperLeft: CGPoint(x: frame.minX, y: frame.minY),
                                  upperRight: CGPoint(x: frame.maxX, y: frame.minY),
                                  lowerRight: CGPoint(x: frame.maxX, y: frame.maxY),
                                  lowerLeft: CGPoint(x: frame.minX, y: frame.maxY))
        let destination = Quadrilateral(upperLeft: points[0],
                                        upperRight: points[1],
                                        lowerRight: points[3],
                                        lowerLeft: points[2])
        return OpenCVWrapper.transform(start, to: destination)
    }

    func algebraTransform() -> CATransform3D {
        let destination = QuadrilateralCalc()
        destination.topLeft = points[0]
        destination.topRight = points[1]
        destination.bottomLeft = points[2]
        destination.bottomRight = points[3]

        let start = QuadrilateralCalc()
        start.topLeft = CGPoint(x: frame.minX, y: frame.minY)
        start.topRight = CGPoint(x: frame.maxX, y: frame.minY)
        start.bottomLeft = CGPoint(x: frame.minX, y: frame.maxY)
        start.bottomRight = CGPoint(x: frame.maxX, y: frame.maxY)

        return start.rectToQuad(rect: start.box(), quad: destination)
    }

    func testCompareSolutions() {
        let openCV = openCVTransform()
        let algebra = algebraTransform()
        let exactlyEqual = CATransform3DEqualToTransform(openCV, algebra)

        XCTAssertFalse(exactlyEqual, "should not be exactly the same")
        let openCVValues = openCV.flattened()
        for (index, value) in algebra.flattened().enumerated() {
            print(value)
            print(openCVValues[index])
            XCTAssert(fabs(value - openCVValues[index]) < 0.0001)
            //            XCTAssertEqual(value, openCVValues[index], accuracy: 0.0001) // TODO: try this again, CRASH on mac
        }
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
