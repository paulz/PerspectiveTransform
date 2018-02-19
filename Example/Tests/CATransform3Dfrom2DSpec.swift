import Quick
import Nimble
@testable import PerspectiveTransform
import simd
import GameKit

func threeValues<S>(_ factory: (()->S)) -> [S] {
    return Array(0...2).map{_ in factory()}
}

extension GKRandomSource {
    func nextDouble() -> Double {
        return Double(nextUniform())
    }
    func nextVector() -> Vector3Type {
        return Vector3Type(threeValues(nextDouble))
    }
    func nextMatrix() -> Matrix3x3Type {
        return Matrix3x3Type(threeValues(nextVector))
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

                    it("should have zeros in third column and row") {
                        let projection2D = source.nextMatrix()
                        let projection3D = projection2D.to3d()
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
                }
            }
        }
    }
}
