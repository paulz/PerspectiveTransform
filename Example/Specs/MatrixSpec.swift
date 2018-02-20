import Quick
import Nimble
import simd
@testable import PerspectiveTransform

class MatrixSpec: QuickSpec {
    override func spec() {
        describe("matrix") {

            let m = float2x2(rows: [
                float2(  4,  3),
                float2(  3,  2)
                ])

            context("inverse") {
                let inverse = m.inverse

                it("should match expected") {
                    // http://www.mathwords.com/i/inverse_of_a_matrix.htm
                    let expectInvert = float2x2(rows: [
                        float2( -2,  3),
                        float2(  3, -4)
                        ])
                    expect(inverse) == expectInvert
                }

                it("should multiply with original and result identity") {
                    let multiply = m * inverse
                    let identity = float2x2(1)
                    expect(multiply) == identity
                }
            }

            context("determinant") {
                it("should match expected") {
                    expect(m.determinant) == -1
                    expect(m.inverse.determinant) == -1
                }

                it("should match math word 2x2 example") {
                    // http://www.mathwords.com/d/determinant.htm
                    // | 1   2 |
                    // |       | = 1*4-2*3 = -2
                    // | 3   4 |
                    expect(float2x2([float2(1,2), float2(3,4)]).determinant) == -2
                }

                it("should match math word 3x3 example") {
                    // http://www.mathwords.com/d/determinant.htm
                    // | 1 2 3 |
                    // | 4 5 6 | = (1*5*9+2*6*7+3*4*8)-(3*5*7+2*4*9+1*6*8) = 0
                    // | 7 8 9 |
                    // See: https://www.google.com/search?client=safari&rls=en&q=(1*5*9%2B2*6*7%2B3*4*8)-(3*5*7%2B2*4*9%2B1*6*8)+=&ie=UTF-8&oe=UTF-8
                    expect(Matrix3x3Type([1,2,3,4,5,6,7,8,9]).determinant) == 0
                }
            }
        }
    }
}

