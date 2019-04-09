//
//  CATransform3D+float3x3.swift
//  Pods
//
//  Created by Paul Zabelin on 2/21/16.
//
//

import simd

extension Vector3 {
    static let one = Vector3(repeating: .one)
    static let lastIndex = Vector3().scalarCount - 1
    static let indexSlice = 0...Vector3.lastIndex
}

extension Scalar {
    static let one = Scalar(1)
}

extension Matrix3x3 {
    fileprivate func insertRowBeforeLast() -> Matrix3x4 {
        return .zeroRowBeforeLast * self
    }
    
    /**~~~
     m11 m12 m13          m11/m33 m12/m33 0 m13/m33
     m21 m22 m23    =>    m21/m33 m22/m33 0 m23/m33
     m31 m32 m33             0       0    1    0
                          m31/m33 m32/m33 0    1
     */
    func to3d() -> Matrix4x4 {
        var m4x4 = zNormalized().insertRowBeforeLast().insertColumnBeforeLast()
        m4x4[Vector3.lastIndex, Vector3.lastIndex] = .one
        return m4x4
    }
    
    private func zNormalized() -> Matrix3x3 {
        return normalizationFactor * self
    }
    
    private var normalizationFactor: Scalar {
        let zScale = self[Vector3.lastIndex, Vector3.lastIndex]
        assert(zScale.isZero == false, "since we use homogenized vectors, z != 0")
        return .one / zScale
    }
}

fileprivate typealias Matrix3x4 = double3x4
fileprivate typealias Matrix4x3 = double4x3

extension Matrix4x3 {
    /**~~~
     1 0 0 0
     0 1 0 0
     0 0 0 1
     */
    fileprivate static let zeroColumnBeforeLast: Matrix4x3 =  {
        let identity = Matrix3x3(diagonal: .one)
        var columns = Vector3.indexSlice.map {identity[$0]}
        columns.insert(.zero, at: Vector3.lastIndex)
        return .init(columns)
    }()
}

extension Matrix3x4 {
    /**~~~
     1 0 0
     0 1 0
     0 0 0
     0 0 1
     */
    fileprivate static let zeroRowBeforeLast: Matrix3x4 = Matrix4x3.zeroColumnBeforeLast.transpose
    
    fileprivate func insertColumnBeforeLast() -> Matrix4x4 {
        return self * .zeroColumnBeforeLast
    }
}

