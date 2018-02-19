//
//  CATransform3D+float3x3.swift
//  Pods
//
//  Created by Paul Zabelin on 2/21/16.
//
//

import simd

extension Vector3Type {
    static let one = Vector3Type(ScalarType.one)
    static let zero = Vector3Type(0)
    static let lastIndex = Vector3Type().endIndex - 1
}

extension ScalarType {
    static let one = ScalarType(1)
}

extension Matrix3x3Type {

    internal static let insertBeforeLastColumn : Matrix4x3Type =  {
        let identity = Matrix3x3Type(diagonal: Vector3Type.one)
        var columns = Array(0...Vector3Type.lastIndex).map{identity[$0]}
        columns.insert(Vector3Type.zero, at: Vector3Type.lastIndex)
        return Matrix4x3Type(columns)
    }()

    internal static let insertBeforeLastRow : Matrix3x4Type =  {
        return insertBeforeLastColumn.transpose
    }()

    func to3d() -> Matrix4x4Type {
        var stretch = Matrix3x3Type.insertBeforeLastRow * self * Matrix3x3Type.insertBeforeLastColumn
        stretch[Vector3Type.lastIndex, Vector3Type.lastIndex] = ScalarType.one
        return stretch
    }

    func zNormalized() -> Matrix3x3Type {
        return zNormalizedUnsafe()
    }

    func homogeneousInverse() -> Matrix3x3Type {
        return inverse.zNormalizedSafe()
    }

    private func zNormalizedUnsafe() -> Matrix3x3Type {
        return (ScalarType.one / normalizationFactor()) * self
    }

    private func normalizationFactor() -> ScalarType {
        return self[Vector3Type.lastIndex, Vector3Type.lastIndex]
    }

    private func zNormalizedSafe() -> Matrix3x3Type {
        return normalizationFactor().isZero ? self : zNormalizedUnsafe()
    }
}
