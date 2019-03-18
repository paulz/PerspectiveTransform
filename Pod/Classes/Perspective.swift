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
    let vectors: [Vector3]
    
    init(_ quad: Quadrilateral) {
        vectors = quad.corners.map {$0.homogeneous3dvector}
    }
    
    internal lazy var basisVectorsToPointsMap = calculateBasisVectorsToPointsMap()
    internal lazy var pointsToBasisVectorsMap = basisVectorsToPointsMap.inverse
    
    internal func projection(to destination: Perspective) -> Matrix3x3 {
        return destination.basisVectorsToPointsMap * pointsToBasisVectorsMap
    }
    
    private func calculateBasisVectorsToPointsMap() -> Matrix3x3 {
        let baseVectors = Matrix3x3(Array(vectors[Vector3.indexSlice]))
        let solution = baseVectors.inverse * vectors[Vector3.lastIndex + 1]
        let scale = Matrix3x3(diagonal: solution)
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
