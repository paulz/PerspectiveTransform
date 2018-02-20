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
        }
    }
}
