import Quick
import Nimble
import PerspectiveTransform

struct MatrixMethod: TransformMatrixCalculator {
    func transform(frame: CGRect, points: [CGPoint]) -> CATransform3D {
        return Perspective(frame).projectiveTransform(destination: Perspective(points))
    }
}

class CompareMethodsSpec: QuickSpec {
    override func spec() {
        describe("compare different methods") {
            context("AlgebraMethod") {
                itBehavesLike("transformer") {["method": AlgebraMethod()]}
            }
            context("PerspectiveTrasform") {
                itBehavesLike("transformer") {["method": MatrixMethod()]}
            }
        }
    }
}
