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
    lazy var pointsToBasisVectorsMap: Matrix3x3Type = basisVectorsToPointsMap.inverse

    internal func projection(to:Perspective) -> Matrix3x3Type {
        return to.basisVectorsToPointsMap * pointsToBasisVectorsMap
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
    public var debugDescription: String {
        return "Perspective: [\n" +
            vectors.map {String(describing: $0)}.joined(separator: "\n") +
        "\n]"
    }
}
