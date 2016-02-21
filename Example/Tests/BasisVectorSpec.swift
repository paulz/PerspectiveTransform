import Quick
import Nimble
import simd
@testable import PerspectiveTransform

class BasisSpec: QuickSpec {
    override func spec() {
        let start = Quadrilateral(CGRect(origin: CGPointZero, size: CGSize(width: 152, height: 122)))
        let destination = Quadrilateral(
            CGRect(
                origin: CGPoint(x: 100, y: 100),
                size: CGSize(width: 200, height: 200)
            )
        )

        context("multiply adj by vector") {
            it("should match expected") {
                let adjM = float3x3([-122, -152, 18544, 122, 0, 0, 0, 152, 0])
                let vector = float3([152, 122, 1])
                let result = adjM * vector
                let expected = float3([-18544, 18544, 18544])
                expect(result) == expected
            }
        }

        context("basis") {
            it("should match fiddle") {
                let startBasis = float3x3([0, 2818688, 0, 0, 0, 2262368, -18544, 18544, 18544]).zNormalized()
                let result = start.basisVector()
                expect(result) ≈ startBasis ± 0.5
            }

            it("should work for destination") {
                let destBasis = float3x3([-4000000, 12000000, 4000000, -4000000, 4000000, 12000000, -40000, 40000, 40000]).zNormalized()
                let result = destination.basisVector()
                expect(result) ≈ destBasis ± 0.5
            }
        }
    }
}
