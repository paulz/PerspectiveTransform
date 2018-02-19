//
//  Perspective.swift
//  Pods
//
//  Created by Paul Zabelin on 2/21/16.
//
//

import simd

public final class Perspective {
    let vectors : [Vector3Type]

    public init(_ q: Quadrilateral) {
        vectors = q.corners.map{$0.homogeneous3dvector}
    }

    lazy var basisVectorsToPointsMap: Matrix3x3Type = calculateBasisVectorsToPointsMap()
    lazy var pointsToBasisVectorsMap: Matrix3x3Type = basisVectorsToPointsMap.homogeneousInverse()

    internal func projection(to:Perspective) -> Matrix3x3Type {
        return (to.basisVectorsToPointsMap * pointsToBasisVectorsMap).zNormalized()
    }

    private func calculateBasisVectorsToPointsMap() -> Matrix3x3Type {
        let baseVectors = Matrix3x3Type(Array(vectors[0...2]))
        let solution = baseVectors.homogeneousInverse() * vectors[3]
        let scale = Matrix3x3Type(diagonal: solution)
        let basisToPoints = baseVectors * scale
        return basisToPoints.zNormalized()
    }
}

extension Perspective: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Perspective: [\n" +
            vectors.map {String(describing: $0)}.joined(separator: "\n") +
        "\n]"
    }
}
