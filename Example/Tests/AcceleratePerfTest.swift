//
//  AcceleratePerfTest.swift
//  PerspectiveTransform
//
//  Created by Paul Zabelin on 2/22/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import Accelerate

func invert(matrix : [Double]) -> [Double] {
    var inMatrix:[Double]       = matrix
    // Get the dimensions of the matrix. An NxN matrix has N^2
    // elements, so sqrt( N^2 ) will return N, the dimension
    var N:__CLPK_integer        = __CLPK_integer( sqrt( Double( matrix.count ) ) )
    // Initialize some arrays for the dgetrf_(), and dgetri_() functions
    var pivots:[__CLPK_integer] = [__CLPK_integer](count: Int(N), repeatedValue: 0)
    var workspace:[Double]      = [Double](count: Int(N), repeatedValue: 0.0)
    var error: __CLPK_integer   = 0
    // Perform LU factorization
    dgetrf_(&N, &N, &inMatrix, &N, &pivots, &error)
    // Calculate inverse from LU factorization
    dgetri_(&N, &inMatrix, &N, &pivots, &workspace, &N, &error)
    return inMatrix
}

class AcceleratePerfTest: XCTestCase {

    func testPerformanceExample() {
        let m: [Double] = [ 1, 2, 3, 0, 1, 4, 5, 6, 0 ]
        
        self.measureBlock {
            0.stride(to: 100000, by: 1).forEach({ (_) -> () in
                _ = invert( m )
            })
//
//
//            print( m_inv )
//            
        }
    }

}
