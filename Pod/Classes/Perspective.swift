//
//  Perspective.swift
//  Pods
//
//  Created by Paul Zabelin on 2/21/16.
//
//

import simd

/**
    3D Perspective represented on 2D by 4 corners polygon
 */
public final class Perspective {
    let vectors: [Vector3Type]

    init(_ quad: Quadrilateral) {
        vectors = quad.corners.map {$0.homogeneous3dvector}
    }

    internal lazy var basisVectorsToPointsMap = calculateBasisVectorsToPointsMap()
    internal lazy var pointsToBasisVectorsMap = basisVectorsToPointsMap.inverse

    internal func projection(to destination: Perspective) -> Matrix3x3Type {
        return destination.basisVectorsToPointsMap * pointsToBasisVectorsMap
    }

    private func calculateBasisVectorsToPointsMap() -> Matrix3x3Type {
        let baseVectors = Matrix3x3Type(Array(vectors[Vector3Type.indexSlice]))
        let solution = baseVectors.inverse * vectors[Vector3Type.lastIndex + 1]
        let scale = Matrix3x3Type(diagonal: solution)
        let basisToPoints = baseVectors * scale
        return basisToPoints
    }
}

extension Perspective: CustomDebugStringConvertible {
    /**
     returns String listing perspective vectors
     */
    public var debugDescription: String {
        return "Perspective: [\n" +
            vectors.map {String(describing: $0)}.joined(separator: "\n") +
        "\n]"
    }
}
