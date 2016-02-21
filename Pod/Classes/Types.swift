//
//  Types.swift
//  Pods
//
//  Created by Paul Zabelin on 2/21/16.
//
//

import simd

#if arch(arm64) || arch(x86_64)
    typealias ScalarType = Double
    typealias Vector3Type = double3
    typealias Matrix3x3Type = double3x3
    typealias Matrix3x4Type = double3x4
    typealias Matrix4x3Type = double4x3
    typealias Matrix4x4Type = double4x4
#else
    typealias ScalarType = Float
    typealias Vector3Type = float3
    typealias Matrix3x3Type = float3x3
    typealias Matrix3x4Type = float3x4
    typealias Matrix4x3Type = float4x3
    typealias Matrix4x4Type = float4x4
#endif

