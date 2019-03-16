//
//  CATransform3D+float3x3.swift
//  Pods
//
//  Created by Paul Zabelin on 2/21/16.
//
//

import simd

extension Vector3Type {
    static let one = Vector3Type(.one)
    static let zero = Vector3Type(0)
    static let lastIndex = Vector3Type().endIndex - 1
    static let indexSlice = 0...Vector3Type.lastIndex
    static let indexArray = Array(Vector3Type.indexSlice)
}

extension ScalarType {
    static let one = ScalarType(1)
}

extension Matrix4x3Type {
    /**~~~
    1 0 0 0
    0 1 0 0
    0 0 0 1
     */
    fileprivate static let zeroColumnBeforeLast: Matrix4x3Type =  {
        let identity = Matrix3x3Type(diagonal: .one)
        var columns = Vector3Type.indexArray.map {identity[$0]}
        columns.insert(.zero, at: Vector3Type.lastIndex)
        return .init(columns)
    }()
}

extension Matrix3x4Type {
    /**~~~
     1 0 0
     0 1 0
     0 0 0
     0 0 1
     */
    fileprivate static let zeroRowBeforeLast: Matrix3x4Type = Matrix4x3Type.zeroColumnBeforeLast.transpose

    fileprivate func insertColumnBeforeLast() -> Matrix4x4Type {
        return self * .zeroColumnBeforeLast
    }
}

extension Matrix3x3Type {
    fileprivate func insertRowBeforeLast() -> Matrix3x4Type {
        return .zeroRowBeforeLast * self
    }

    /**~~~
     m11 m12 m13          m11/m33 m12/m33 0 m13/m33
     m21 m22 m23    =>    m21/m33 m22/m33 0 m23/m33
     m31 m32 m33             0       0    1    0
                          m31/m33 m32/m33 0    1
     */
    func to3d() -> Matrix4x4Type {
        var m4x4 = zNormalized().insertRowBeforeLast().insertColumnBeforeLast()
        m4x4[Vector3Type.lastIndex, Vector3Type.lastIndex] = .one
        return m4x4
    }

    private func zNormalized() -> Matrix3x3Type {
        return normalizationFactor * self
    }

    private var normalizationFactor: ScalarType {
        let zScale = self[Vector3Type.lastIndex, Vector3Type.lastIndex]
        assert(zScale.isZero == false, "since we use homogenized vectors, z != 0")
        return .one / zScale
    }
}
