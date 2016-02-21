import Quick
import Nimble
@testable import PerspectiveTransform
import simd

class HomogeneousInverseSpec: QuickSpec {
    override func spec() {
        describe("homogeneousInverse") {
            context("multiply adj by vector") {
                let m = Matrix3x3Type([-122, -152, 18544, 122, 0, 0, 0, 152, 0])
                let expected = Matrix3x3Type([[0.0, 0.0, 1.0], [152.0, -0.0, 1.0], [-0.0, 122.0, 1.0]])

                it("should match expected") {
                    expect(m.homogeneousInverse().zNormalized()).to(beCloseTo(expected))
                }
            }
        }
    }
}
