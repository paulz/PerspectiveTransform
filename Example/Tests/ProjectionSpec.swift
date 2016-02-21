import Quick
import Nimble
import simd
@testable import PerspectiveTransform

class ProjectionSpec: QuickSpec {
    override func spec() {

        describe("general2DProjection") {
            context("fiddle") {
                let expected = float3x3([-335626817536000000, 0, -25507638132736000000, 0, -418158002176000000, -25507638132736000000, 0, 0, -255076381327360000])

                it("should match") {
                    let start = Quadrilateral(CGRect(origin: CGPointZero, size: CGSize(width: 152, height: 122)))
                    let destination = Quadrilateral(
                        CGRect(
                            origin: CGPoint(x: 100, y: 100),
                            size: CGSize(width: 200, height: 200)
                        )
                    )

                    let projection = start.general2DProjection(destination)
                    let expectedNormalized = zNormalize(expected)
                    expect(projection) == expectedNormalized
                }

                context("transform") {
                    it("should create 3D transformation") {
                        let expectedNormalized = zNormalize(expected)
                        let transform3D = CATransform3D(expectedNormalized)
                        expect(CATransform3DIsAffine(transform3D)) == true
                        let translate = CATransform3DMakeTranslation(100, 100, 0)
                        let scale = CATransform3DMakeScale(200.0/152, 200.0/122, 1)
                        let combined = CATransform3DConcat(translate, scale)
                        expect(CATransform3DEqualToTransform(combined, transform3D)) == false
                        let expAffine = CATransform3DGetAffineTransform(scale)
                        let affine = CATransform3DGetAffineTransform(transform3D)
                        expect(CGAffineTransformEqualToTransform(affine, expAffine)) != true
                    }
                }
            }
        }
    }
}
