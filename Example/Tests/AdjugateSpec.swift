import Quick
import Nimble
import simd

func adjugateViaInverse(matrix:float3x3) -> float3x3 {
    let det = matrix_determinant(matrix.cmatrix)
    let adjugate = det * matrix.inverse
    return adjugate
}

func adjugateViaCofactors(matrix:float3x3) -> float3x3 {
    // TODO: calculate cofactors
    return matrix
}

extension float3x3 {
    init(_ array:[Float]) {
        let row1 = float3(Array(array[0...2]))
        let row2 = float3(Array(array[3...5]))
        let row3 = float3(Array(array[6...8]))
        let rows = [row1, row2, row3]
        self.init(rows: rows)
    }

    func toA() -> [Float] {
        let t = transpose
        return t[0].toA() + t[1].toA() + t[2].toA()
    }

}

class Quardilateral {
    let p1 : CGPoint
    let p2 : CGPoint
    let p3 : CGPoint
    let p4 : CGPoint
    init(_ points:[CGPoint]) {
        p1 = points[0]
        p2 = points[1]
        p3 = points[2]
        p4 = points[3]
    }
    convenience init(_ origin:CGPoint, _ size:CGSize) {
        self.init([
            origin,
            CGPointApplyAffineTransform(origin, CGAffineTransformMakeTranslation(size.width, 0)),
            CGPointApplyAffineTransform(origin, CGAffineTransformMakeTranslation(0, size.height)),
            CGPointApplyAffineTransform(origin, CGAffineTransformMakeTranslation(size.width, size.height)),
            ])
    }
    convenience init(_ rect:CGRect) {
        self.init(rect.origin, rect.size)
    }
}

extension float3 {
    init(_ point:CGPoint) {
        self.init(Float(point.x), Float(point.y), 1)
    }

    func toA() -> [Float] {
        return [x, y, z]
    }
}

func first3(quad:Quardilateral) -> float3x3 {
    let v1 = float3(quad.p1)
    let v2 = float3(quad.p2)
    let v3 = float3(quad.p3)
    return float3x3([v1, v2, v3])
}

func basis(quad:Quardilateral) -> float3x3 {
    let m = first3(quad)
    let v4 = float3(quad.p4)
    let adjM = adjugateViaInverse(m)
    let v = adjM * v4
    let diag = float3x3(diagonal: v)
    let result = m * diag
    return result
}

func normalize(input:float3x3) -> float3x3 {
    return (Float(1) / input[2,2]) * input
}

func general2DProjection(from:Quardilateral, to:Quardilateral) -> float3x3 {
    var source = basis(from)
    source = normalize(source)
    var destination = basis(to)
    destination = normalize(destination)
    print(destination.toA())
    let result = destination * adjugateViaInverse(source)
    return normalize(result)
}

func expandNoZ(matrix:float3x3) -> float4x3 {
    var noZ = float4x3()
    noZ[0,0]=1
    noZ[1,1]=1
    noZ[3,2]=1
    return matrix * noZ
}

func expandNoZ(matrix:float4x3) -> float4x4 {
    var noZ = float3x4()
    noZ[0,0]=1
    noZ[1,1]=1
    noZ[2,3]=1
    var result = noZ * matrix
    result[2,2] = 1
    return result
}


func transform(matrix:float3x3) -> CATransform3D {
  let c = matrix.toA().map{CGFloat($0)}
  return CATransform3D(
    m11: c[0], m12: c[3], m13: 0, m14: 0,
    m21: 0, m22: 0, m23: 0, m24: 0,
    m31: 0, m32: 0, m33: 0, m34: 0,
    m41: 0, m42: 0, m43: 0, m44: 0
  )
}

class ProjectionSpec: QuickSpec {
    override func spec() {

        describe("general2DProjection") {
            context("fiddle") {
                let expected = float3x3([-335626817536000000, 0, -25507638132736000000, 0, -418158002176000000, -25507638132736000000, 0, 0, -255076381327360000])

                it("should match") {
                    let start = Quardilateral(CGRect(origin: CGPointZero, size: CGSize(width: 152, height: 122)))
                    let destination = Quardilateral(
                        CGRect(
                            origin: CGPoint(x: 100, y: 100),
                            size: CGSize(width: 200, height: 200)
                        )
                    )

                    let projection = general2DProjection(start, to: destination)
                    let expectedNormalized = normalize(expected)
                    expect(projection) == expectedNormalized
                }

                context("expandNoZ") {
                    let expectedNormalized = normalize(expected)

                    it("should add empty space") {
                        let expanded = expandNoZ(expectedNormalized)
                        expect(expanded[0]) == expectedNormalized[0]
                        expect(expanded[1]) == expectedNormalized[1]
                        expect(expanded[2]) == float3()
                        expect(expanded[3]) == expectedNormalized[2]
                    }

                    it("should expand to 4x4") {
                        let expanded = expandNoZ(expandNoZ(expectedNormalized))
                        var withZ1 = float4()
                        withZ1[2] = 1
                        expect(expanded[2]) == withZ1
                    }
                }
            }
        }
    }
}

class BasisSpec: QuickSpec {
    override func spec() {
        let start = Quardilateral(CGRect(origin: CGPointZero, size: CGSize(width: 152, height: 122)))
        let destination = Quardilateral(
            CGRect(
                origin: CGPoint(x: 100, y: 100),
                size: CGSize(width: 200, height: 200)
            )
        )


        context("multiply adj by vector") {
            it("should match expected") {
                let adjM = float3x3([-122, -152, 18544, 122, 0, 0, 0, 152, 0])
                let vector = float3([152, 122, 1])
                let result = adjM * vector
                let expected = float3([-18544, 18544, 18544])
                expect(result) == expected
            }
        }

        context("basis") {
            it("should match fiddle") {
                let startBasis = float3x3([0, 2818688, 0, 0, 0, 2262368, -18544, 18544, 18544])
                let result = basis(start)
                expect(result) ≈ startBasis ± 0.5
            }

            it("should work for destination") {
                let destBasis = float3x3([-4000000, 12000000, 4000000, -4000000, 4000000, 12000000, -40000, 40000, 40000])
                let result = basis(destination)
                expect(result) ≈ destBasis ± 0.5
            }
        }


        context("perspective") {
            it("should match expected") {

            }

        }
    }
}

class AdjugateSpec: QuickSpec {
    override func spec() {
        context("adjugateViaInverse") {
            // http://www.mathwords.com/a/adjoint.htm
            it("should match expected") {
                let a = float3x3(rows: [
                    float3(  1,  2,  3),
                    float3(  0,  4,  5),
                    float3(  1,  0,  6)
                    ])
                let b = float3x3(rows: [
                    float3(  24, -12,  -2),
                    float3(   5,   3,  -5),
                    float3(  -4,   2,   4)
                    ])
                expect(adjugateViaInverse(a)) == b
            }
            
            it("should match fiddle") {
                // http://jsfiddle.net/dFrHS/3/
                let input = float3x3([0, 152, 0, 0, 0, 122, 1, 1, 1])
                let output = float3x3([-122, -152, 18544, 122, 0, 0, 0, 152, 0])
                expect(adjugateViaInverse(input)) == output
            }
        }
        
    }
}
