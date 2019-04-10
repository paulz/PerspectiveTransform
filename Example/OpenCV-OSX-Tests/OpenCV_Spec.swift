import Quick
import Nimble

typealias OpenCVTransformer = (Quadrilateral, Quadrilateral) -> CATransform3D

struct OpenCVAdapter: TransformMatrixCalculator {
    var method: OpenCVTransformer

    func transform(frame: CGRect, points: [CGPoint]) -> CATransform3D {
        let start = Quadrilateral(upperLeft: CGPoint(x: frame.minX, y: frame.minY),
                                  upperRight: CGPoint(x: frame.maxX, y: frame.minY),
                                  lowerRight: CGPoint(x: frame.maxX, y: frame.maxY),
                                  lowerLeft: CGPoint(x: frame.minX, y: frame.maxY))
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
