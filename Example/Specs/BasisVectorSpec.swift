import Quick
import Nimble
import simd
@testable import PerspectiveTransform

class BasisSpec: QuickSpec {
    override func spec() {
        let start = Quadrilateral(CGRect(origin: CGPoint.zero, size: CGSize(width: 152, height: 122)))
        let destination = Quadrilateral(
            CGRect(
                origin: CGPoint(x: 100, y: 100),
                size: CGSize(width: 200, height: 200)
            )
        )

        context("multiply adj by vector") {
            it("should match expected") {
                let adjM = Matrix3x3Type([-122, -152, 18544, 122, 0, 0, 0, 152, 0])
                let vector = Vector3Type([152, 122, 1])
                let result = adjM * vector
                let expected = Vector3Type([-18544, 18544, 18544])
                expect(result).to(equal(expected))
            }
        }

        context("basis") {
            it("should match expected") {
                let startBasis = Matrix3x3Type([[0.0, 0.0, -1.0], [152.0, 0.0, 1.0], [0.0, 122.0, 1.0]])
                expect(Perspective(start).basisVectorsToPointsMap) ≈ (startBasis, delta:0.5)
            }

            it("should work for destination") {
                let destBasis = Matrix3x3Type([[-100.0, -100.0, -1.0], [300.0, 100.0, 1.0], [100.0, 300.0, 1.0]])
                expect(Perspective(destination).basisVectorsToPointsMap) ≈ (destBasis, delta:0.5)
            }
        }
    }
}
