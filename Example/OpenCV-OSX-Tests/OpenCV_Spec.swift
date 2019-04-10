import Quick
import Nimble

typealias OpenCVTransformer = (Quadrilateral, Quadrilateral) -> CATransform3D

struct OpenCVAdapter: TransformMatrixCalculator {
    var method: OpenCVTransformer

    func transform(frame: CGRect, points: [CGPoint]) -> CATransform3D {
        let corners = frame.corners()
        let start = Quadrilateral(upperLeft: corners[0],
                                  upperRight: corners[1],
                                  lowerRight: corners[3],
                                  lowerLeft: corners[2])
        let destination = Quadrilateral(upperLeft: points[0],
                                        upperRight: points[1],
                                        lowerRight: points[3],
                                        lowerLeft: points[2])

        return method(start, destination)
    }
}

class OpenCV_Spec: QuickSpec {
    override func spec() {
        describe("OpenCV") {
            context("OpenCVWrapper") {
                itBehavesLike("transformer") {["method": OpenCVAdapter(method: OpenCVWrapper.perspectiveTransform(_:to:))]}
                itBehavesLike("transformer") {["method": OpenCVAdapter(method: OpenCVWrapper.findHomography(from:to:))]}
            }
        }
    }
}
