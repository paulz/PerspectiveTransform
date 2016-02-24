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


class AccelerateSolvePerfTest: XCTestCase {

    func solve( A:[Double], _ B:[Double] ) -> [Double] {
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
        var pivots:[__CLPK_integer] = [__CLPK_integer](count: Int(N), repeatedValue: 0)
        var error: __CLPK_integer   = 0
        // Perform LU factorization
        dgetrf_(&N, &N, &inMatrix, &N, &pivots, &error)
        // Calculate solution from LU factorization
        _ = "T".withCString {
            dgetrs_( UnsafeMutablePointer($0), &N, &NRHS, &inMatrix, &LDA, &pivots, &solution, &LDB, &error )
        }
        return solution
    }
    
    func testSolvePerformance() {
        let start = Quadrilateral(CGRect(origin: CGPointZero, size: CGSize(width: 152, height: 122)))
        let destination = Quadrilateral(
            CGRect(
                origin: CGPoint(x: 100, y: 100),
                size: CGSize(width: 200, height: 200)
            )
        )
        start.corners
        destination.corners

        func row1(p1:CGPoint, p2:CGPoint) -> [Double] {
            return [p1.x,p1.y,1,0,0,0,-p2.x*p1.x,-p2.x*p1.y].map{Double($0)}
        }

        func row2(p1:CGPoint, p2:CGPoint) -> [Double] {
            return [0,0,0,p1.x,p1.y,1,-p2.y*p1.x,-p2.y*p1.y].map{Double($0)}
        }

//        let empty: [Double] = []
        let A = 0.stride(through: 3, by: 1).map{
            row1(start.corners[$0], p2: destination.corners[$0]) +
            row2(start.corners[$0], p2: destination.corners[$0])
            }.reduce([],combine: +)

        let B = 0.stride(through: 3, by: 1).map{[destination.corners[$0].x, destination.corners[$0].y]}.reduce([], combine:+).map{Double($0)}

//        let A: [Double] = [ 1, 1, 4, 6 ]
//        let B: [Double] = [ 383, 2034 ]

        let solution = solve(A, B)
        print(solution)

        self.measureBlock {

            0.stride(to: 100000, by: 1).forEach({ (_) -> () in
                _ = self.solve( A, B )
            })


        }
    }
    
}
