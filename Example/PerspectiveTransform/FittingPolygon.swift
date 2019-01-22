//
//  FittingPolygon.swift
//  Example
//
//  Created by Paul Zabelin on 3/12/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import CoreGraphics

class FittingPolygon {
    var points: [CGPoint] = []

    init(svgPointsString: String) {
        let formatter = NumberFormatter()
        let eightNumbers: [CGFloat] = svgPointsString.split(separator: " ").map { substring in
            let string = String(substring)
            let number = formatter.number(from: string)
            return CGFloat(truncating: number!)
        }
        for point in stride(from: 0, to: 7, by: 2) {
            let x = eightNumbers[point]
            let y = eightNumbers[point + 1]
            points.append(CGPoint(x: x, y: y))
        }
        assert(points.count == 4, "should have 4 point")
        points = [points[3], points[0], points[2], points[1]]
        print("points:", points)
    }

    class func loadFromSvgFile() -> FittingPolygon {
        let loader = PolygonLoader(fileName: "with-overlay.svg")
        return FittingPolygon(svgPointsString: loader.loadPoints())
    }
}
