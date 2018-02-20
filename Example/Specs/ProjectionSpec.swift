import Quick
import Nimble
import simd
@testable import PerspectiveTransform

class ProjectionSpec: QuickSpec {
    override func spec() {
        describe("general2DProjection") {
            context("isosceles trapezoid") {
                var from: Perspective!
                var to: Perspective!

                beforeEach {
                    from = Perspective(CGRect(origin: CGPoint.zero, size: CGSize(width: 1, height: 1)))
                    to = Perspective(
                        CGPoint(x: -1, y: 0), // shifted left by 1
                        CGPoint(x: 2, y: 0), // shifted right by 1
                        CGPoint(x: 1, y: 1),
                        CGPoint(x: 0, y: 1)
                    )
                }

                it("should be non affine and have 3D rotation") {
                    let transform = from.projectiveTransform(destination: to)
                    expect(CATransform3DIsIdentity(transform)) == false
                    expect(CATransform3DIsAffine(transform)) == false
                }
            }
            context("to the same perspective") {
                var from: Perspective!
                var to: Perspective!

                beforeEach {
                    from = Perspective(CGRect(origin: CGPoint.zero, size: CGSize(width: 10, height: 10)))
                    to = from
                }

                it("should be identity") {
                    let projection = from.projection(to: to)
                    let transform3D = CATransform3D(projection.to3d())
                    expect(CATransform3DIsIdentity(transform3D)) == true
                    let layer = CALayer()
                    layer.transform = transform3D
                    expect(layer.value(forKeyPath: "transform.scale") as? Double) == 1
                    expect(layer.value(forKeyPath: "transform.translation") as? CGSize) == CGSize.zero
                    expect(layer.value(forKeyPath: "transform.rotation") as? Double) == 0
                }
            }

            context("rotation") {
                // Image showing 3D transform matrix values
                // https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreAnimation_guide/Art/transform_manipulations_2x.png
                var from: Perspective!
                var to: Perspective!

                beforeEach {
                    var points = Quadrilateral(CGRect(origin: CGPoint.zero, size: CGSize(width: 10, height: 10))).corners
                    from = Perspective(points)
                    let turnedRight = [points[1], points[3], points[0], points[2]]
                    to = Perspective(turnedRight)
                }

                it("should match rotate around 0,0 and translate back to 0") {
                    let rotate3D = CATransform3DMakeRotation(.pi / 2, 0, 0, 1)
                    let translate3D = CATransform3DMakeTranslation(10, 0, 0)
                    let combined = CATransform3DConcat(rotate3D, translate3D)

                    let projection = from.projection(to: to)
                    expect(CATransform3D(projection.to3d())) == combined
                }

                context("matrix values") {
                    var matrix: CATransform3D!

                    beforeEach {
                        let projection = from.projection(to: to)
                        matrix = CATransform3D(projection.to3d())
                    }

                    it("should contain rotation around z axis") {
                        let angle = CGFloat.pi / 2
                        expect(matrix.m11) ≈ cos(angle)
                        expect(matrix.m22) ≈ cos(angle)
                        expect(matrix.m33) == 1
                        expect(matrix.m12) ≈ sin(angle)
                        expect(matrix.m21) ≈ -sin(angle)
                        expect(matrix.m13) == 0
                        expect(matrix.m31) == 0
                    }

                    it("should have key path components of rotation and translation") {
                        let layer = CALayer()
                        layer.transform = matrix
                        expect(layer.value(forKeyPath: "transform.scale") as? Double) == 1
                        expect(layer.value(forKeyPath: "transform.translation") as? CGSize) == CGSize(width: 10, height: 0)
                        expect(layer.value(forKeyPath: "transform.rotation.x") as? Double) == 0
                        expect(layer.value(forKeyPath: "transform.rotation.y") as? Double) == 0
                        expect(layer.value(forKeyPath: "transform.rotation.z") as? Double) ≈ Double.pi / 2
                        expect(layer.value(forKeyPath: "transform.rotation") as? Double) == layer.value(forKeyPath: "transform.rotation.z") as! Double
                    }
                }
            }

            context("scale and translate") {
                let expected = Matrix3x3Type([200.0/152, 0, 100,
                                              0, 200.0/122, 100,
                                              0, 0, 1])
                var start: Perspective!
                var destination: Perspective!

                beforeEach {
                    start = Perspective(CGRect(origin: CGPoint.zero, size: CGSize(width: 152, height: 122)))
                    destination = Perspective(
                        CGRect(
                            origin: CGPoint(x: 100, y: 100),
                            size: CGSize(width: 200, height: 200)
                        )
                    )
                }

                it("should match expected") {
                    let projection = start.projection(to: destination)
                    expect(projection) ≈ expected
                }

                context("concat") {
                    var expected3D: CATransform3D!
                    var translate3D: CATransform3D!
                    var scale3D: CATransform3D!

                    beforeEach {
                        expected3D = CATransform3D(expected.to3d())
                        translate3D = CATransform3DMakeTranslation(100, 100, 0)
                        scale3D = CATransform3DMakeScale(200.0/152, 200.0/122, 1)
                    }

                    it("should create 3D transformation scale + translate, in that order only") {
                        expect(CATransform3DConcat(scale3D, translate3D)) == expected3D
                        expect(CATransform3DConcat(translate3D, scale3D)) != expected3D
                    }

                    context("expected 3d matrix") {
                        it("should contain scale values on the diagonal") {
                            [expected3D, scale3D].forEach { transform3d in
                                let matrix = transform3d!
                                expect(matrix.m11) == 200.0/152
                                expect(matrix.m22) == 200.0/122
                                expect(matrix.m33) == 1
                                expect(matrix.m44) == 1
                            }
                        }

                        it("should contain translate values in row 4") {
                            [expected3D, translate3D].forEach { transform3d in
                                let matrix = transform3d!
                                expect(matrix.m41) == 100
                                expect(matrix.m42) == 100
                                expect(matrix.m43) == 0
                                expect(matrix.m44) == 1
                            }
                        }

                        context("without scale and translate") {
                            var matrix: CATransform3D!

                            beforeEach {
                                matrix = expected3D!
                                matrix.m11 = 1
                                matrix.m22 = 1
                                matrix.m41 = 0
                                matrix.m42 = 0
                            }

                            it("should have no other value and thus be identity") {
                                expect(CATransform3DIsIdentity(matrix)) == true
                            }
                        }
                    }


                    context("affine 2D") {
                        var scale2D: CGAffineTransform!
                        var translate2D: CGAffineTransform!
                        var expected2D: CGAffineTransform!

                        beforeEach {
                            scale2D = CATransform3DGetAffineTransform(scale3D)
                            translate2D = CATransform3DGetAffineTransform(translate3D)
                            expected2D = CATransform3DGetAffineTransform(expected3D)
                        }

                        it("should all be affine") {
                            let isAffine = [scale3D, translate3D, expected3D].map {CATransform3DIsAffine($0)}
                            expect(isAffine).to(allPass(beTrue()))
                        }

                        it("should create 2D affine tranformation") {
                            expect(scale2D.concatenating(translate2D)) == expected2D
                        }
                    }
                }
            }
        }
    }
}
