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
                    #if arch(arm64) || arch(x86_64)
                        expect(inverse) == expectInvert
                    #else
                        expect(inverse) != expectInvert
                        expect(inverse) == float2x2(rows: [
                            float2(  -1,  1),
                            float2(  4.0/3,  -1)
                            ])
                    #endif
                }

                it("should multiply with original and result identity") {
                    let multiply = m * inverse
                    let identity = float2x2(1)
                    #if arch(arm64) || arch(x86_64)
                        expect(multiply) == identity
                    #else
                        expect(multiply) != identity
                        expect(multiply) == float2x2(rows: [
                            float2(  0,  1),
                            float2(  -1.0/3,  1)
                            ])
                    #endif
                }

                #if arch(arm64) || arch(x86_64)
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
                #endif

            }
            context("determinant") {
                it("should match expected") {
                    expect(m.determinant) == -1
                }
            }
        }
    }
}
