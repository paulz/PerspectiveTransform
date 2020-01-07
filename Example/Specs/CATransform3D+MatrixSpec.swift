import Quick
import Nimble
import simd
@testable import PerspectiveTransform

class CATransform3D_MatrixSpec: QuickSpec {
    override func spec() {
        describe("CATransform3D") {
            var m4x4: double4x4!

            beforeEach {
                let columns: [SIMD4<Double>] = (1...4).map { row in
                    SIMD4<Double>((1...4).map {Double(10 * row + $0)})
                }
                m4x4 = double4x4(columns)
            }
            context("unsafeBitCast") {
                it("should be safe for compatible memory layouts") {
                    expect(MemoryLayout<double4x4>.size) == MemoryLayout<CATransform3D>.size
                    expect(MemoryLayout<double4x4>.stride) == MemoryLayout<CATransform3D>.stride
                    expect(MemoryLayout<double4x4>.alignment) == 2 * MemoryLayout<CATransform3D>.alignment

                    let transform = unsafeBitCast(m4x4!, to: CATransform3D.self)
                    expect(transform.m11) == CGFloat(m4x4[0, 0])
                }
            }
            context("init") {
                it("should create CATransform3D with the same values as 4x4 matrix") {
                    expect(m4x4[0, 0]) == 11
                    expect(m4x4[0, 1]) == 12
                    expect(m4x4[1, 0]) == 21
                    expect(m4x4[3, 3]) == 44

                    let transform = CATransform3D(m4x4)
                    expect(transform.m11) == 11
                    expect(transform.m12) == 12
                    expect(transform.m21) == 21
                    expect(transform.m44) == 44
                }
            }
        }
    }
}
