import Quick
import Nimble
@testable import PerspectiveTransform
import simd

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

            context("CGRect.zero") {
                it("should have Not A Number vectors") {
                    let perspective = Perspective(CGRect.zero)
                    for row in stride(from: 0, to: 2, by: 1) {
                        for col in stride(from: 0, to: 2, by: 1) {
                            expect(perspective.basisVectorsToPointsMap[row][col].isNaN) == true
                            expect(perspective.pointsToBasisVectorsMap[row][col].isNaN) == true
                        }
                    }
                }
            }

            context("basisVectorsToPointsMap") {
                context("rectangle") {
                    let perspective = Perspective(CGRect(origin: CGPoint.zero, size: CGSize(width: 10, height: 20)))

                    it("should be homegenious vector to corners") {
                        expect(perspective.basisVectorsToPointsMap) == Matrix3x3Type(Vector3Type(0.0, 0.0, -1.0),
                                                                                     Vector3Type(10.0, 0.0, 1.0),
                                                                                     Vector3Type(0.0, 20.0, 1.0))
                    }

                    context("pointsToBasisVectorsMap") {
                        let identity = Matrix3x3Type(diagonal: Vector3Type(1))

                        it("should result in identity when multiplied by basisVectorsToPointsMap") {
                            expect(perspective.basisVectorsToPointsMap * perspective.pointsToBasisVectorsMap) == identity
                        }
                    }
                }
            }
        }
    }
}
