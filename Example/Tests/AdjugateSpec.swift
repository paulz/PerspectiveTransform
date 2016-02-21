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

                    let projection = general2DProjection(start, to: destination)
                    let expectedNormalized = normalize(expected)
                    expect(projection) == expectedNormalized
                }

                context("expandNoZ") {
                    let expectedNormalized = normalize(expected)

                    it("should add empty space") {
                        let expanded = expandNoZ(expectedNormalized)
                        expect(expanded[0]) == expectedNormalized[0]
                        expect(expanded[1]) == expectedNormalized[1]
                        expect(expanded[2]) == float3()
                        expect(expanded[3]) == expectedNormalized[2]
                    }

                    it("should expand to 4x4") {
                        let expanded = expandNoZ(expandNoZ(expectedNormalized))
                        var withZ1 = float4()
                        withZ1[2] = 1
                        expect(expanded[2]) == withZ1
                    }
                }
                context("transform") {
                    it("should create 3D transformation") {
                        let expectedNormalized = normalize(expected)
                        let expanded = expandNoZ(expandNoZ(expectedNormalized))
                        let transform3D = transform(expanded)
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
                let startBasis = normalize(float3x3([0, 2818688, 0, 0, 0, 2262368, -18544, 18544, 18544]))
                let result = basis(start)
                expect(result) ≈ startBasis ± 0.5
            }

            it("should work for destination") {
                let destBasis = normalize(float3x3([-4000000, 12000000, 4000000, -4000000, 4000000, 12000000, -40000, 40000, 40000]))
                let result = basis(destination)
                expect(result) ≈ destBasis ± 0.5
            }
        }
    }
}
