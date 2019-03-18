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
                let perspective = Perspective(CGRect.zero)

                it("should have Not A Number vectors") {
                    for row in stride(from: 0, to: 2, by: 1) {
                        for col in stride(from: 0, to: 2, by: 1) {
                            expect(perspective.basisVectorsToPointsMap[row][col].isNaN) == true
                            expect(perspective.pointsToBasisVectorsMap[row][col].isNaN) == true
                        }
                    }
                }

                it("should create Not A Number matrix to itself") {
                    var values = perspective.projectiveTransform(destination: perspective).flattened()
                    expect(values[10]) == 1.0
                    values.remove(at: 10)
                    expect(values).to(allPass {$0!.isNaN})
                }

                it("should create Not A Number matrix to a valid perspective") {
                    let destination = Perspective(CGRect(x: 0, y: 0, width: 1, height: 1))
                    var values = perspective.projectiveTransform(destination: destination).flattened()
                    expect(values[10]) == 1.0
                    values.remove(at: 10)
                    expect(values).to(allPass {$0!.isNaN})
                }
            }

            context("vectors") {
                it("should be homogeneous 3d vector for each corner") {
                    let perspective = Perspective(CGRect(origin: CGPoint.zero, size: CGSize(width: 10, height: 20)))
                    expect(perspective.vectors) ≈ [
                        Vector3(0, 0, 1),
                        Vector3(10, 0, 1),
                        Vector3(0, 20, 1),
                        Vector3(10, 20, 1)
                    ]
                }
            }

            context("basisVectorsToPointsMap") {
                context("rectangle") {
                    let perspective = Perspective(CGRect(origin: CGPoint.zero, size: CGSize(width: 10, height: 20)))

                    it("should be homegenious vector to corners") {
                        expect(perspective.basisVectorsToPointsMap) == Matrix3x3(Vector3(0.0, 0.0, -1.0),
                                                                                 Vector3(10.0, 0.0, 1.0),
                                                                                 Vector3(0.0, 20.0, 1.0))
                    }

                    it("should convert basis vectors to points") {
                        let points = basisVectors.map {perspective.basisVectorsToPointsMap * $0}
                        expect(points) ≈ [
                            Vector3(0, 0, -1),
                            Vector3(10, 0, 1),
                            Vector3(0, 20, 1),
                            Vector3(10, 20, 1)
                            ]
                    }

                    context("pointsToBasisVectorsMap") {
                        it("should result in identity when multiplied by basisVectorsToPointsMap") {
                            let identity = Matrix3x3(diagonal: Vector3(1))
                            expect(perspective.basisVectorsToPointsMap * perspective.pointsToBasisVectorsMap) == identity
                        }

                        it("should convert points to basis vectors") {
                            let points = [
                                Vector3(0, 0, -1),
                                Vector3(10, 0, 1),
                                Vector3(0, 20, 1),
                                Vector3(10, 20, 1)
                            ]
                            let vectors = points.map {perspective.pointsToBasisVectorsMap * $0}
                            expect(vectors) ≈ basisVectors
                        }
                    }
                }
            }
        }
    }
}
