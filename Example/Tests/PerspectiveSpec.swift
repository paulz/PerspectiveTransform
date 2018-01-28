import Quick
import Nimble
@testable import PerspectiveTransform

class PerspectiveSpec: QuickSpec {
    override func spec() {
        describe("Perspective") {
            context("debug description") {
                it("should list all vectors") {
                    let perspective = Perspective(CGRect.zero)
                    expect(String(describing: perspective)) == "Perspective: [\n"
                    + "double3(0.0, 0.0, 1.0)\n"
                    + "double3(0.0, 0.0, 1.0)\n"
                    + "double3(0.0, 0.0, 1.0)\n"
                    + "double3(0.0, 0.0, 1.0)\n"
                    + "]"
                }
            }
        }
    }
}
