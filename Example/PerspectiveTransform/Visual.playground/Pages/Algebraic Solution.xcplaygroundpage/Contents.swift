//: [Previous](@previous)

//: Algebraic Solution Leads to the same result visually

import Foundation
import UIKit
import CoreGraphics
import PlaygroundSupport

let page = PlaygroundPage.current

let containerImage = #imageLiteral(resourceName: "container.jpg")

let containerView = UIImageView(image: containerImage)
page.liveView = containerView
let overlayView = UIView()
overlayView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
let overlayView2 = UIView()
overlayView2.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
overlayView.alpha = 0.5
overlayView2.alpha = 0.5
containerView.addSubview(overlayView)
containerView.addSubview(overlayView2)

overlayView.frame = CGRect(origin: CGPoint.zero,
                           size: CGSize(width: 20, height: 10))
overlayView.resetAnchorPoint()
overlayView2.frame = CGRect(origin: CGPoint.zero,
                           size: CGSize(width: 20, height: 10))
overlayView2.resetAnchorPoint()

let points = [
    CGPoint(x: 108.315837, y: 80.1687782),
    CGPoint(x: 377.282671, y: 41.4352201),
    CGPoint(x: 193.321418, y: 330.023027),
    CGPoint(x: 459.781253, y: 251.836131)
]

let destination = QuadrilateralCalc()
destination.topLeft = points[0]
destination.topRight = points[1]
destination.bottomLeft = points[2]
destination.bottomRight = points[3]

let start = QuadrilateralCalc()
start.topLeft = CGPoint(x: overlayView.frame.minX, y: overlayView.frame.minY)
start.topRight = CGPoint(x: overlayView.frame.maxX, y: overlayView.frame.minY)
start.bottomLeft = CGPoint(x: overlayView.frame.minX, y: overlayView.frame.maxY)
start.topLeft = CGPoint(x: overlayView.frame.maxX, y: overlayView.frame.maxY)

let toPlace = start.rectToQuad(rect: start.box(), quad: destination)

//: Compare to perspective

import PerspectiveTransform
let from = Perspective(overlayView2.frame)
let to = Perspective(points)
let matrix = from.projectiveTransform(destination: to)
print("algrbra: ", toPlace)
print("perspective: ", matrix)
CATransform3DEqualToTransform(matrix, toPlace)
overlayView.layer.transform = toPlace
overlayView2.layer.transform = matrix

//: Single point rect should produce identity matrix

let q = QuadrilateralCalc()
q.topLeft = CGPoint(x: 0, y: 0)
q.topRight = CGPoint(x: 1, y: 0)
q.bottomLeft = CGPoint(x: 0, y: 1)
q.bottomRight = CGPoint(x: 1, y: 1)

q.box()
q.box() == CGRect(x: 0, y: 0, width: 1, height: 1)

let transform = q.rectToQuad(rect: q.box(), quad: q)
CATransform3DIsIdentity(transform)

//: [Next](@next)
