//
//  CATransform3D+float3x3.swift
//  Pods
//
//  Created by Paul Zabelin on 2/21/16.
//
//

import QuartzCore
import simd

extension Matrix3x3Type {
    static let addColumn : Matrix4x3Type =  {
        var m = Matrix4x3Type(diagonal:Vector3Type(1,1,0))
        m[3,2] = 1
        return m
    }()

    static let addRow : Matrix3x4Type =  {
        var m = Matrix3x4Type(diagonal:Vector3Type(1,1,0))
        m[2,3] = 1
        return m
    }()

    func to3d() -> Matrix4x4Type {
        var result = Matrix3x3Type.addRow * self * Matrix3x3Type.addColumn
        result[2,2] = 1
        return result
    }

    func zNormalized() -> Matrix3x3Type {
        #if arch(arm64) || arch(x86_64)
            return zNormalizedUnsafe()
        #else
            return zNormalizedSafe()
        #endif
    }

    func homogeneousInverse() -> Matrix3x3Type {
        #if arch(arm64) || arch(x86_64)
            return self.inverse
        #else
            return adjugate()
        #endif
    }

    private func zNormalizedUnsafe() -> Matrix3x3Type {
        return (ScalarType(1) / self[2,2]) * self
    }

    private func zNormalizedSafe() -> Matrix3x3Type {
        return self[2,2]==0 ? self : zNormalizedUnsafe()
    }

    private func adjugate()-> Matrix3x3Type {
        return Matrix3x3Type(rows:[
            Vector3Type(
                ScalarType(self[1,1]*self[2,2]-self[2,1]*self[1,2]),
                ScalarType(self[2,0]*self[1,2]-self[1,0]*self[2,2]),
                ScalarType(self[1,0]*self[2,1]-self[2,0]*self[1,1])
            ),
            Vector3Type(
                ScalarType(self[2,1]*self[0,2]-self[0,1]*self[2,2]),
                ScalarType(self[0,0]*self[2,2]-self[2,0]*self[0,2]),
                ScalarType(self[2,0]*self[0,1]-self[0,0]*self[2,1])
            ),
            Vector3Type(
                ScalarType(self[0,1]*self[1,2]-self[1,1]*self[0,2]),
                ScalarType(self[1,0]*self[0,2]-self[0,0]*self[1,2]),
                ScalarType(self[0,0]*self[1,1]-self[1,0]*self[0,1])
            )
            ]).zNormalized()
    }
}
