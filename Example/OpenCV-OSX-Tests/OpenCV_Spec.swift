import Quick
import Nimble

class OpenCV_Spec: QuickSpec {
    override func spec() {
        describe("OpenCV") {
            context("OpenCVWrapper") {
                context("transform") {
                    it("should be identity for same start and destination") {
                        let start = Quadrilateral(upperLeft: CGPoint.zero,
                                                  upperRight: CGPoint(x: 10, y: 0),
                                                  lowerRight: CGPoint(x: 0, y: 10),
                                                  lowerLeft: CGPoint(x: 10, y: 10))
                        let desination = start
                        var transform = OpenCVWrapper.transform(start, to: desination)
                        expect(transform.m41.exponent) <= -40
                        expect(transform.m42.exponent) <= -40
                        transform.m41 = transform.m41.rounded(.towardZero)
                        transform.m42 = transform.m42.rounded(.towardZero)

                        expect(CATransform3DIsIdentity(transform)) == true
                    }
                }
            }
        }
    }
}
