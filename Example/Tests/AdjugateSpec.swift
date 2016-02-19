import Quick
import Nimble
import simd

func adjugateViaInverse(matrix:float3x3) -> float3x3 {
    let det = matrix_determinant(matrix.cmatrix)
    let adjugate = det * matrix.inverse
    return adjugate
}

class AdjugateSpec: QuickSpec {
    override func spec() {
        context("adjugateViaInverse") {
            // http://www.mathwords.com/a/adjoint.htm
            it("should match expected") {
                let a = float3x3(rows: [
                    float3(  1,  2,  3),
                    float3(  0,  4,  5),
                    float3(  1,  0,  6)
                    ])
                let b = float3x3(rows: [
                    float3(  24, -12,  -2),
                    float3(   5,   3,  -5),
                    float3(  -4,   2,   4)
                    ])
                expect(adjugateViaInverse(a)) == b
            }
        }

    }
}
