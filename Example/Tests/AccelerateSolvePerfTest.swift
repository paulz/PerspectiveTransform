//
//  AccelerateSolvePerfTest.swift
//  PerspectiveTransform
//
//  Created by Paul Zabelin on 2/23/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import Accelerate
import PerspectiveTransform

@discardableResult
func solve(_ A:[Double], _ B:[Double] ) -> [Double] {
    var inMatrix:[Double]       = A
    var solution:[Double]       = B
    // Get the dimensions of the matrix. An NxN matrix has N^2
    // elements, so sqrt( N^2 ) will return N, the dimension
    var N:__CLPK_integer        = __CLPK_integer( sqrt( Double( A.count ) ) )
    // Number of columns on the RHS
    var NRHS:__CLPK_integer     = 1
    // Leading dimension of A and B
    var LDA:__CLPK_integer      = N
    var LDB:__CLPK_integer      = N
    // Initialize some arrays for the dgetrf_(), and dgetri_() functions
    var pivots:[__CLPK_integer] = [__CLPK_integer](repeating: 0, count: Int(N))
    var error: __CLPK_integer   = -1
    // Perform LU factorization
    dgetrf_(&LDA, &LDB, &inMatrix, &N, &pivots, &error)
    XCTAssertEqual(0, error, "should be successful")
    // Calculate solution from LU factorization
    _ = "T".withCString {
        // Solves a general system of linear equations, after factorization
        dgetrs_( UnsafeMutablePointer(mutating: $0), &N, &NRHS, &inMatrix, &LDA, &pivots, &solution, &LDB, &error )
    }
    XCTAssertEqual(0, error, "should be successful")
    return solution
}

class AccelerateSolvePerfTest: XCTestCase {
    static let reasonableTestDurationMs = 100
    var repeatTimes = AccelerateSolvePerfTest.reasonableTestDurationMs * 200

    var A: [Double]?
    var B: [Double]?

    func testSolveCorrectness() {
        A = [ 1, 1, 4, 6 ]
        B = [ 383, 2034 ]
        XCTAssertEqual([ 132.0, 251.0 ], solve(A!, B!))
    }

    func preparePerspective() {
        let start = Quadrilateral(CGRect(origin: CGPoint.zero, size: CGSize(width: 152, height: 122)))
        let destination = Quadrilateral(
            CGRect(
                origin: CGPoint(x: 100, y: 100),
                size: CGSize(width: 200, height: 200)
            )
        )
        print(start.corners)
        print(destination.corners)

        func row1(p1:CGPoint, p2:CGPoint) -> [Double] {
            return [p1.x,p1.y,1,0,0,0,-p2.x*p1.x,-p2.x*p1.y].map{Double($0)}
        }

        func row2(p1:CGPoint, p2:CGPoint) -> [Double] {
            return [0,0,0,p1.x,p1.y,1,-p2.y*p1.x,-p2.y*p1.y].map{Double($0)}
        }

        //        let empty: [Double] = []
        A = stride(from: 0, through: 3, by: 1).map{
            row1(p1: start.corners[$0], p2: destination.corners[$0]) +
                row2(p1: start.corners[$0], p2: destination.corners[$0])
            }.reduce([],{$0! + $1})

        B = stride(from: 0, through: 3, by: 1).map{[destination.corners[$0].x, destination.corners[$0].y]}.reduce([], +).map{Double($0)}
    }

    func testSolvePerspectiveCorrectness() {
        preparePerspective()
        let solution = solve(A!, B!)
        let accuracy = 0.000000001
        XCTAssertEqual(solution[0], 1.31578947368421, accuracy: accuracy)
        XCTAssertEqual(solution[1], 0, accuracy: accuracy)
        XCTAssertEqual(solution[2], 100, accuracy: accuracy)
        XCTAssertEqual(solution[3], 0, accuracy: accuracy)
        XCTAssertEqual(solution[4], 1.63934426229508, accuracy: accuracy)
        XCTAssertEqual(solution[5], 100, accuracy: accuracy)
        XCTAssertEqual(solution[6], 0, accuracy: accuracy)
        XCTAssertEqual(solution[7], 0, accuracy: accuracy)
    }


    func testSolvePerformance() {
        preparePerspective()
        measure {
            repeatTimes.times {
                solve( self.A!, self.B! )
            }
        }
    }
}
