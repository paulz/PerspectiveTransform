import Quick
import Nimble
import QuartzCore
@testable import PerspectiveTransform

class CALayerTransformSpec: QuickSpec {
    override func spec() {
        describe("CALayer.transform") {
            context("translation") {
                it("should have x,y,z") {
                    let transform = CATransform3DMakeTranslation(1, 2, 3)
                    let layer = CALayer()
                    layer.transform = transform

                    var translate = Vector3Type()
                    translate.x = layer.value(forKeyPath: "transform.translation.x") as! Double
                    translate.y = layer.value(forKeyPath: "transform.translation.y") as! Double
                    translate.z = layer.value(forKeyPath: "transform.translation.z") as! Double

                    expect(translate.x) == 1
                    expect(translate.y) == 2
                    expect(translate.z) == 3
                }
            }

            context("rotation") {
                context("around one axis") {
                    it("should match rotation.x component") {
                        let transform = CATransform3DMakeRotation(0.1234, 1, 0, 0)
                        var rotate = transform.layerRotation()

                        expect(rotate.x) == 0.1234
                        expect(rotate.y) == 0
                        expect(rotate.z) == 0
                    }
                    context("other axis") {
                        it("should match corresponding value") {
                            expect(CATransform3DMakeRotation(0.1234, 0, 10, 0).layerRotation()) == Vector3Type(0, 0.1234, 0)
                            expect(CATransform3DMakeRotation(0.1234, 0, 0, 10).layerRotation()) == Vector3Type(0, 0, 0.1234)
                        }
                    }
                    context("vector length") {
                        it("should be ignored") {
                            expect(CATransform3DMakeRotation(0.1234, 1000, 0, 0).layerRotation()) == Vector3Type(0.1234, 0, 0)
                        }
                    }
                    context("large angles") {
                        it("should be wrapped by asin") {
                            let transform = CATransform3DMakeRotation(100, 1, 0, 0)
                            var rotate = transform.layerRotation()

                            expect(rotate.x) == asin(sin(100))
                            expect(rotate.y) == 0
                            expect(rotate.z) == 0
                        }
                    }
                }
                context("three values") {
                    it("should match") {
                        let multiplier: CGFloat = 20.0
                        let original = CATransform3DMakeRotation(0.1, 0.02, 0.03, 0.04).layerRotation()
                        expect(CATransform3DMakeRotation(0.1,
                                                         multiplier * 0.02,
                                                         multiplier * 0.03,
                                                         multiplier * 0.04).layerRotation()) ≈
                            (original, delta:0.001)
                    }
                }
            }
        }
    }
}
