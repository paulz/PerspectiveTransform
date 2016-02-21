import Quick
import Nimble
@testable import PerspectiveTransform
import simd

class CATransform3Dfrom2DSpec: QuickSpec {
    override func spec() {
        describe("weak perspective projection") {
            context("2D to 3D") {
                it("should preserve z values") {
                    let projection2D = float3x3([
                        float3(11,12,13),
                        float3(21,22,23),
                        float3(31,32,33),
                        ])
                    let projection3D = CATransform3D(
                        m11: 11, m12: 12, m13: 0, m14: 13,
                        m21: 21, m22: 22, m23: 0, m24: 23,
                        m31: 0,  m32: 0,  m33: 1, m34: 0,
                        m41: 31, m42: 32, m43: 0, m44: 33)
                    let constructed = CATransform3D(projection2D.to3d())
                    expect(CATransform3DEqualToTransform(constructed, projection3D)) == true
                }
            }
        }
    }
}
