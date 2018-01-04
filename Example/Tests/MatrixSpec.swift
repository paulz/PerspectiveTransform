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

            }
            context("determinant") {
                it("should match expected") {
                    expect(m.determinant) == -1
                }
            }
        }
    }
}
