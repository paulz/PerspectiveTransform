import Quick
import Nimble
@testable import PerspectiveTransform
import simd
import GameKit

func arrayWith<S>(_ factory: (()->S)) -> [S] {
    return Array(Vector3Type.indexSlice).map{_ in factory()}
}

extension GKRandomSource {
    func nextDouble() -> Double {
        return Double(nextUniform())
    }
    func nextVector() -> Vector3Type {
        return Vector3Type(arrayWith(nextDouble))
    }
    func nextMatrix() -> Matrix3x3Type {
        return Matrix3x3Type(arrayWith(nextVector))
    }
}


class CATransform3Dfrom2DSpec: QuickSpec {
    override func spec() {
        describe("weak perspective projection") {
            context("2D to 3D") {
                it("should add row and column and set 1 for z") {
                    let projection2D = Matrix3x3Type([
                        Vector3Type(11,12,13),
                        Vector3Type(21,22,23),
                        Vector3Type(31,32,33),
                        ])
                    let projection3D = CATransform3D(
                        m11: 11, m12: 12, m13: 0, m14: 13,
                        m21: 21, m22: 22, m23: 0, m24: 23,
                        m31: 0,  m32: 0,  m33: 1, m34: 0,
                        m41: 31, m42: 32, m43: 0, m44: 33)
                    expect(CATransform3D(projection2D.to3d())) == projection3D
                }

                context("random matrix") {
                    let source = GKRandomSource.sharedRandom()
                    var matrix: Matrix3x3Type!

                    beforeEach {
                        matrix = source.nextMatrix()
                    }

                    it("should have zeros in third column and row") {
                        let projection3D = matrix.to3d()
                        let third = 2
                        expect(projection3D[0,third]) == 0
                        expect(projection3D[1,third]) == 0
                        expect(projection3D[2,third]) == 1
                        expect(projection3D[3,third]) == 0

                        expect(projection3D[third,0]) == 0
                        expect(projection3D[third,1]) == 0
                        expect(projection3D[third,2]) == 1
                        expect(projection3D[third,3]) == 0
                    }

                    context("layer") {
                        it("should have components") {
                            let transform = CATransform3D(matrix.to3d())
                            let layer = CALayer()
                            layer.transform = transform
                            var scale = Vector3Type()
                            scale.x = layer.value(forKeyPath: "transform.scale.x") as! Double
                            scale.y = layer.value(forKeyPath: "transform.scale.y") as! Double
                            scale.z = layer.value(forKeyPath: "transform.scale.z") as! Double
                            let madeScale = CATransform3DMakeScale(CGFloat(scale.x), CGFloat(scale.y), CGFloat(scale.z))
                            print("madeScale:",madeScale)

                            var translate = Vector3Type()
                            translate.x = layer.value(forKeyPath: "transform.translation.x") as! Double
                            translate.y = layer.value(forKeyPath: "transform.translation.y") as! Double
                            translate.z = layer.value(forKeyPath: "transform.translation.z") as! Double
                            let madeTranslation = CATransform3DMakeTranslation(CGFloat(translate.x), CGFloat(translate.y), CGFloat(translate.z))
                            print("madeTranslation:",madeTranslation)

                            let rotate = transform.layerRotation()
                            print("scale, translate, rotate = ", scale, translate, rotate)
                            let b = atan(transform.m12/transform.m22)
                            let p = asin(transform.m32)
                            let h = atan(transform.m31/transform.m33)
                            let angle = b*b + p*p + h*h
                            let madeRotation = CATransform3DMakeRotation(angle, b, p, h)
                            print("madeRotation:",madeRotation)
                        }
                    }
                }
            }
        }
    }
}
