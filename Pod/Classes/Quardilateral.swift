//
//  Quadrilateral.swift
//  Pods
//
//  Created by Paul Zabelin on 2/20/16.
//
//

import simd

public func adjugateViaInverse(matrix:float3x3) -> float3x3 {
    let det = matrix_determinant(matrix.cmatrix)
    let adjugate = det * matrix.inverse
    return adjugate
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

extension float4 {
    func toA() -> [Float] {
        return [x,y,z,w]
    }
}

extension float4x4 {
    func toA() -> [Float] {
        let t = transpose
        return t[0].toA() + t[1].toA() + t[2].toA() + t[3].toA()
    }
    func toAA() -> [[Float]] {
        let t = transpose
        return [t[0].toA(), t[1].toA(), t[2].toA(), t[3].toA()]
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

func first3(quad:Quadrilateral) -> float3x3 {
    let v1 = float3(quad.p1)
    let v2 = float3(quad.p2)
    let v3 = float3(quad.p3)
    return float3x3([v1, v2, v3])
}

func basis(quad:Quadrilateral) -> float3x3 {
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

func general2DProjection(from:Quadrilateral, to:Quadrilateral) -> float3x3 {
    var source = basis(from)
    source = normalize(source)
    var destination = basis(to)
    destination = normalize(destination)
    var result = destination * adjugateViaInverse(source)
    result = normalize(result)
    print(result.toA())
    return result
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


func transform(matrix:float4x4) -> CATransform3D {
    let c = matrix.transpose.toAA().map{$0.map{CGFloat($0)}}
    return CATransform3D(
        m11: c[0][0], m12: c[0][1], m13: c[0][2], m14: c[0][3],
        m21: c[1][0], m22: c[1][1], m23: c[1][2], m24: c[1][3],
        m31: c[2][0], m32: c[2][1], m33: c[2][2], m34: c[2][3],
        m41: c[3][0], m42: c[3][1], m43: c[3][2], m44: c[3][3]
    )
}

public class Quadrilateral {
    public let p1 : CGPoint
    public let p2 : CGPoint
    public let p3 : CGPoint
    public let p4 : CGPoint
    init(_ points:[CGPoint]) {
        p1 = points[0]
        p2 = points[1]
        p3 = points[2]
        p4 = points[3]
    }
    public convenience init(_ origin:CGPoint, _ size:CGSize) {
        self.init([
            origin,
            CGPointApplyAffineTransform(origin, CGAffineTransformMakeTranslation(size.width, 0)),
            CGPointApplyAffineTransform(origin, CGAffineTransformMakeTranslation(0, size.height)),
            CGPointApplyAffineTransform(origin, CGAffineTransformMakeTranslation(size.width, size.height)),
            ])
    }
    public convenience init(_ rect:CGRect) {
        self.init(rect.origin, rect.size)
    }
}


