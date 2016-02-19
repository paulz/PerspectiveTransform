import Quick
import Nimble
import simd

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
                    expect(matrix_determinant(m.cmatrix)) == -1
                }
            }
        }
    }
}
