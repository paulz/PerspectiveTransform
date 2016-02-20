import Quick
import Nimble
import simd

func adjugateViaInverse(matrix:float3x3) -> float3x3 {
    let det = matrix_determinant(matrix.cmatrix)
    let adjugate = det * matrix.inverse
    return adjugate
}

func adjugateViaCofactors(matrix:float3x3) -> float3x3 {
    // TODO: calculate cofactors
    return matrix
}

extension float3x3 {
    init(_ array:[Float]) {
        let row1 = float3(Array(array[0...2]))
        let row2 = float3(Array(array[3...5]))
        let row3 = float3(Array(array[6...8]))
        let rows = [row1, row2, row3]
        self.init(rows)
    }
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

            it("should match fiddle") {
                // http://jsfiddle.net/dFrHS/3/
                let input = float3x3([0, 152, 0, 0, 0, 122, 1, 1, 1])
                let output = float3x3([-122, -152, 18544, 122, 0, 0, 0, 152, 0])
                expect(adjugateViaInverse(input)) == output
            }
        }

    }
}
