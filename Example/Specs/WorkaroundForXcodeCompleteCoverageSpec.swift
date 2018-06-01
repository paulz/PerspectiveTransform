import Quick
import Nimble
@testable import PerspectiveTransform

class WorkaroundForXcodeCompleteCoverageSpec: QuickSpec {
    // Workaround for Xcode bug: http://www.openradar.me/radar?id=5065986117992448
    override func spec() {
        describe(String(describing: Quadrilateral.init(_:_:))) {
            context("to workaround Xcode coverage bug we add this silly test in order to maintain 100% test coverage") {
                it("should be covered by tests") {
                    let optional:Quadrilateral? = Quadrilateral(CGPoint.zero, CGSize.zero)
                    expect(optional).notTo(beNil())
                }
            }
        }
    }
}
