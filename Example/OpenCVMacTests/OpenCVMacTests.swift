//
//  OpenCVMacTests.swift
//  OpenCVMacTests
//
//  Created by Paul Zabelin on 2/28/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest

class OpenCVMacTests: XCTestCase {
    var wrapper: OpenCVWrapper!

    override func setUp() {
        super.setUp()
        wrapper = OpenCVWrapper()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        XCTAssert(wrapper.canBeCalledFromSwift())
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testIdentity() {
        let start = Quadrilateral(upperLeft: CGPoint.zero,
                                  upperRight: CGPoint(x: 10, y: 0),
                                  lowerRight: CGPoint(x: 0, y: 10),
                                  lowerLeft: CGPoint(x: 10, y: 10))
        let desination = start
        var transform = OpenCVWrapper.transform(start, to: desination)
        transform.m41 = transform.m41.rounded(.towardZero)
        transform.m42 = transform.m42.rounded(.towardZero)
        XCTAssert(CATransform3DIsIdentity(transform))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
