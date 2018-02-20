import Quick
import Nimble
@testable import PerspectiveTransform
import simd

class HomogeneousInverseSpec: QuickSpec {
    override func spec() {
        describe("homogeneousInverse") {
            context("multiply adj by vector") {
                let m = Matrix3x3Type([-122, -152, 122 * 152.0,
                                        122,    0, 0,
                                          0,  152, 0])
                let expected = Matrix3x3Type([[  0, 0, 1],
                                              [152, 0, 1],
                                              [0, 122, 1]])

                it("should match expected") {
                    expect(m.homogeneousInverse().zNormalized()) ≈ expected
                }
            }
        }
    }
}
