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

                context(String(describing: Matrix3x3Type.adjugate)) {
                    it("should be result of adjugate when z-normalized") {
                        let before = Matrix3x3Type(diagonal: Vector3Type(5))
                        let adjugate = before.adjugate()
                        let inverse = before.inverse
                        expect(adjugate.zNormalized()) == inverse.zNormalized()
                        expect(inverse.inverse) == before
                        expect(simd_quaternion(adjugate.zNormalized())) == simd_quaternion(inverse.zNormalized())
                    }
                }

            }
            context("determinant") {
                it("should match expected") {
                    expect(m.determinant) == -1
                }
            }
        }
    }
}
