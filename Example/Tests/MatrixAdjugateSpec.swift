import Quick
import Nimble
import simd
@testable import PerspectiveTransform

extension Matrix3x3Type {
    func adjugate()-> Matrix3x3Type {
        let c1 = self[0]
        let c2 = self[1]
        let c3 = self[2]
        return Matrix3x3Type([cross(c2, c3), cross(c3, c1), cross(c1, c2)]).transpose
    }
}

class MatrixAdjugateSpec: QuickSpec {
    override func spec() {
        describe(String(describing: Matrix3x3Type.self)) {
            context("used to calculate inverse on 32-bit platforms, no longer used, as we only suppport 64-bit architectures on iOS11") {
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
        }
    }
}
