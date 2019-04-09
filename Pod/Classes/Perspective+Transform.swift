//
//  Quadrilateral+Transform.swift
//  Pods
//
//  Created by Paul Zabelin on 2/20/16.
//
//

public extension Perspective {
    /**
     Create Perspective based on 4 points
     
     - parameter topLeft: top left corner
     - parameter topRight: top right corner
     - parameter bottomLeft: bottom left corner
     - parameter bottomRight: bottom right corner
     */
    convenience init(_ topLeft: CGPoint, _ topRight: CGPoint, _ bottomLeft: CGPoint, _ bottomRight: CGPoint) {
        self.init(.init(topLeft, topRight, bottomLeft, bottomRight))
    }
    /**
     Create Perspective based on 4 points
     
     - parameter points: corner points, must be size 4
     */
    convenience init(_ points: [CGPoint]) {
        self.init(.init(points))
    }
    /**
     Create Perspective based on 4 corners of the rectangle
     
     - parameter rect: defines the corners
     */
    convenience init(_ rect: CGRect) {
        self.init(.init(rect))
    }
    
    /**
     Calculate CATransform3D to another perspective
     
     - parameter destination: perspective to transform to
     - returns: tranformation matrix from this perspective to destination
     */
    func projectiveTransform(destination: Perspective) -> CATransform3D {
        return .init(projection(to: destination).to3d())
    }
}
