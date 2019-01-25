import Quick
import Nimble
import PerspectiveTransform

typealias Transformer = (CGRect, [CGPoint]) -> CATransform3D

class CompareTransformSpecConfiguration: QuickConfiguration {
    override class func configure(_ configuration: Configuration) {
        sharedExamples("transformer") { context in
            var transformer: TransformMatrixCalculator!

            let points = [
                CGPoint(x: 108.315837, y: 80.1687782),
                CGPoint(x: 377.282671, y: 41.4352201),
                CGPoint(x: 193.321418, y: 330.023027),
                CGPoint(x: 459.781253, y: 251.836131)
                ]
            let frame = CGRect(origin: CGPoint.zero,
                               size: CGSize(width: 20, height: 10))
            beforeEach {
                transformer = context()["method"] as? TransformMatrixCalculator
            }

            it("should be identity for same start and destination") {
                let points = [CGPoint(x: 0, y: 0), CGPoint(x: 20, y: 0), CGPoint(x: 0, y: 10), CGPoint(x: 20, y: 10)]
                let toItself = transformer.transform(frame: frame, points: points)
                expect(toItself) ≈ CATransform3DIdentity
            }

            it("produce the same solution as  algebraic method") {
                let algebra = AlgebraMethod()
                expect(transformer.transform(frame: frame, points: points)) ≈ algebra.transform(frame: frame, points: points)
            }
        }
    }
}

protocol TransformMatrixCalculator {
    func transform(frame: CGRect, points: [CGPoint]) -> CATransform3D
}

struct AlgebraMethod: TransformMatrixCalculator {
    func transform(frame: CGRect, points: [CGPoint]) -> CATransform3D {
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
}

struct MatrixMethod: TransformMatrixCalculator {
    func transform(frame: CGRect, points: [CGPoint]) -> CATransform3D {
        return Perspective(frame).projectiveTransform(destination: Perspective(points))
    }
}

class CompareMethodsSpec: QuickSpec {
    override func spec() {
        describe("compare different methods") {
            context("AlgebraMethod") {
                itBehavesLike("transformer") {["method":AlgebraMethod()]}
            }
            context("PerspectiveTrasform") {
                itBehavesLike("transformer") {["method":MatrixMethod()]}
            }
        }
    }
}
