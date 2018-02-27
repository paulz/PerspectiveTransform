import Quick
import Nimble

struct Quadrilateral {
    var upperLeft, upperRight, lowerRight, lowerLeft:CGPoint
}

class OpenCVWrapper: NSObject {
    func canBeCalledFromSwift() -> Bool {
        return true
    }

    static func transform(_ from:Quadrilateral, to:Quadrilateral) -> CATransform3D {
        return CATransform3DIdentity
    }
}

class OpenCV_Spec: QuickSpec {
    override func spec() {
        describe("opencv") {
            context("OpenCVWrapper") {
                it("can be called from swift") {
                    let wrapper = OpenCVWrapper()
                    expect(wrapper).notTo(beNil())
                    expect(wrapper.canBeCalledFromSwift()) == true
                }

                context("transform") {
                    it("should be identity for same") {
                        let start = Quadrilateral(upperLeft: CGPoint.zero,
                                                  upperRight: CGPoint(x: 10, y: 0),
                                                  lowerRight: CGPoint(x: 0, y: 10),
                                                  lowerLeft: CGPoint(x: 10, y: 10))
                        let desination = start
                        let transform = OpenCVWrapper.transform(start, to: desination)
                        expect(CATransform3DIsIdentity(transform)) == true
                    }
                }

                context("compare with algebraic solution") {
                    let points = [
                        CGPoint(x: 108.315837, y: 80.1687782),
                        CGPoint(x: 377.282671, y: 41.4352201),
                        CGPoint(x: 193.321418, y: 330.023027),
                        CGPoint(x: 459.781253, y: 251.836131),
                        ]
                    let frame = CGRect(origin: CGPoint.zero,
                                       size: CGSize(width: 20, height: 10))

                    func openCVTransform() -> CATransform3D {
                        let start = Quadrilateral(upperLeft: CGPoint(x: frame.minX, y: frame.minY),
                                                  upperRight: CGPoint(x: frame.maxX, y: frame.minY),
                                                  lowerRight: CGPoint(x: frame.maxX, y: frame.maxY),
                                                  lowerLeft: CGPoint(x: frame.minX, y: frame.maxY))
                        let destination = Quadrilateral(upperLeft: points[0],
                                                        upperRight: points[1],
                                                        lowerRight: points[3],
                                                        lowerLeft: points[2])
                        return OpenCVWrapper.transform(start, to: destination)
                    }

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

                    it("should be same") {
                        let openCV = openCVTransform()
                        let algebra = algebraTransform()
                        expect(openCV) ≈ algebra
                    }
                }
            }
        }
    }
}
