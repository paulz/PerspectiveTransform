//
//  CATransform3D+float3x3.swift
//  Pods
//
//  Created by Paul Zabelin on 2/21/16.
//
//

import simd

extension Matrix3x3Type {
    static let lastIndex = 2

    internal static let insertColumn : Matrix4x3Type =  {
        let identity = Matrix3x3Type(diagonal: Vector3Type(1))
        var rows = [identity[0], identity[1], identity[2]]
        rows.insert(Vector3Type(0), at: lastIndex)
        return Matrix4x3Type(rows)
    }()

    internal static let insertRow : Matrix3x4Type =  {
        return insertColumn.transpose
    }()

    func to3d() -> Matrix4x4Type {
        var stretch = Matrix3x3Type.insertRow * self * Matrix3x3Type.insertColumn
        stretch[Matrix3x3Type.lastIndex, Matrix3x3Type.lastIndex] = ScalarType(1)
        return stretch
    }

    func zNormalized() -> Matrix3x3Type {
        return zNormalizedUnsafe()
    }

    func homogeneousInverse() -> Matrix3x3Type {
        return inverse.zNormalizedSafe()
    }

    private func zNormalizedUnsafe() -> Matrix3x3Type {
        return (ScalarType(1) / normalizationFactor()) * self
    }

    private func normalizationFactor() -> ScalarType {
        return self[Matrix3x3Type.lastIndex, Matrix3x3Type.lastIndex]
    }

    private func zNormalizedSafe() -> Matrix3x3Type {
        return normalizationFactor().isZero ? self : zNormalizedUnsafe()
    }
}
