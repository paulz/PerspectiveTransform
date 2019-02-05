import Quick
import Nimble

typealias Transformer = (Quadrilateral, Quadrilateral) -> CATransform3D

class CompareTransformSpecConfiguration: QuickConfiguration {
    override class func configure(_ configuration: Configuration) {
        sharedExamples("transformer") { context in
            var transformer: Transformer!

            beforeEach {
                transformer = context()["method"] as? Transformer
            }

            let start = Quadrilateral(upperLeft: CGPoint.zero,
                                      upperRight: CGPoint(x: 10, y: 0),
                                      lowerRight: CGPoint(x: 0, y: 10),
                                      lowerLeft: CGPoint(x: 10, y: 10))
            it("should be identity for same start and destination") {
                let toItself = transformer(start, start)
                expect(toItself) ≈ CATransform3DIdentity
            }

            let points = [
                CGPoint(x: 108.315837, y: 80.1687782),
                CGPoint(x: 377.282671, y: 41.4352201),
                CGPoint(x: 193.321418, y: 330.023027),
                CGPoint(x: 459.781253, y: 251.836131)
                ]
            let frame = CGRect(origin: CGPoint.zero,
                               size: CGSize(width: 20, height: 10))

            func algebraTransform() -> CATransform3D {
                let destination = QuadrilateralCalc()
                destination.topLeft = points[0]
                destination.topRight = points[1]
                destination.bottomLeft = points[2]
                destination.bottomRight = points[3]

                let start = QuadrilateralCalc()
                start.topLeft = CGPoint(x: frame.minX, y: frame.minY)
                start.topRight = CGPoint(x: frame.maxX, y: frame.minY)
                start.bottomLeft = CGPoint(x: frame.minX, y: frame.maxY)
                start.bottomRight = CGPoint(x: frame.maxX, y: frame.maxY)

                return start.rectToQuad(rect: start.box(), quad: destination)
            }

            it("produce the same solution as  algebraic method") {
                let start = Quadrilateral(upperLeft: CGPoint(x: frame.minX, y: frame.minY),
                                          upperRight: CGPoint(x: frame.maxX, y: frame.minY),
                                          lowerRight: CGPoint(x: frame.maxX, y: frame.maxY),
                                          lowerLeft: CGPoint(x: frame.minX, y: frame.maxY))
                let destination = Quadrilateral(upperLeft: points[0],
                                                upperRight: points[1],
                                                lowerRight: points[3],
                                                lowerLeft: points[2])
                let openCV = transformer(start, destination)
                let algebra = algebraTransform()
                expect(openCV) ≈ algebra
            }
        }
    }
}

class OpenCV_Spec: QuickSpec {
    override func spec() {
        describe("OpenCV") {
            context("OpenCVWrapper") {
                itBehavesLike("transformer") {["method": OpenCVWrapper.perspectiveTransform(_:to:)]}
                itBehavesLike("transformer") {["method": OpenCVWrapper.findHomography(from:to:)]}
            }
        }
    }
}
