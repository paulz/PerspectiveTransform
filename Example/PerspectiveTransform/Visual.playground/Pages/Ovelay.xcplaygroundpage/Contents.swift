//: [Previous](@previous)

import PerspectiveTransform
import XCPlayground

let page = XCPlaygroundPage.currentPage

let containerImage = [#Image(imageLiteral: "container.jpg")#]
let skyImage = [#Image(imageLiteral: "sky.jpg")#]

let containerView = UIImageView(image: containerImage)
page.liveView = containerView
let overlayView = UIImageView(image: skyImage)
containerView.addSubview(overlayView)

overlayView.frame = CGRect(origin: CGPointZero,
    size: CGSize(width: 1, height: 1))
overlayView.resetAnchorPoint()
let start = Perspective(overlayView.frame)
let destination = Perspective([
    CGPoint(x: 108.315837, y: 80.1687782),
    CGPoint(x: 377.282671, y: 41.4352201),
    CGPoint(x: 193.321418, y: 330.023027),
    CGPoint(x: 459.781253, y: 251.836131),
    ])

UIView.animateWithDuration(1.0,
    delay: 0,
    options: [],
    animations: {
        overlayView.layer.transform = start.projectiveTransform(destination)
    },
    completion:nil)


//: [Next](@next)
