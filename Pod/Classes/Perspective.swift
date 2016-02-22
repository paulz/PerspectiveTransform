//
//  Perspective.swift
//  Pods
//
//  Created by Paul Zabelin on 2/21/16.
//
//

import simd

public final class Perspective {
    let quadrilateral : Quadrilateral

    public init(_ q: Quadrilateral) {
        quadrilateral = q
    }

    lazy var basisVectorsToPointsMap: Matrix3x3Type! = {
        let m = Matrix3x3Type([
            self.quadrilateral.p1.homogeneous3dvector,
            self.quadrilateral.p2.homogeneous3dvector,
            self.quadrilateral.p3.homogeneous3dvector]
        )
        let solution = m.homogeneousInverse() * self.quadrilateral.p4.homogeneous3dvector
        let scale = Matrix3x3Type(diagonal: solution)
        let basisToPoints = m * scale
        return basisToPoints.zNormalized()
    }()

    lazy var pointsToBasisVectorsMap: Matrix3x3Type! = {
        self.basisVectorsToPointsMap.homogeneousInverse()
    }()

}