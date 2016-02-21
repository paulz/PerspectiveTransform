//
//  Quadrilateral+Transform.swift
//  Pods
//
//  Created by Paul Zabelin on 2/20/16.
//
//

import UIKit
import simd

public extension Quadrilateral {
    func basisVector() -> float3x3 {
        let m = float3x3([
            float3(p1),
            float3(p2),
            float3(p3)]
        )
        let v4 = float3(p4)
        let v = m.inverse * v4
        let diag = float3x3(diagonal: v)
        let result = m * diag
        return normalize(result)
    }

    func general2DProjection(to:Quadrilateral) -> float3x3 {
        let source = basisVector()
        let destination = to.basisVector()
        let result = destination * source.inverse
        print(result.toA())
        return result
    }

    public func projectiveTransform(quad:Quadrilateral) -> CATransform3D {
        let projection = general2DProjection(quad)
        let expanded = expandNoZ(expandNoZ(projection))
        return CATransform3D(expanded)
    }
}

import simd

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

func normalize(input:float3x3) -> float3x3 {
    return (Float(1) / input[2,2]) * input
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
