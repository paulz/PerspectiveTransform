//: [Previous](@previous)

import PerspectiveTransform
import PlaygroundSupport

let page = PlaygroundPage.current

let containerImage = #imageLiteral(resourceName: "container.jpg")
let skyImage = #imageLiteral(resourceName: "sky.jpg")

let containerView = UIImageView(image: containerImage)
page.liveView = containerView
let overlayView = UIImageView(image: skyImage)
containerView.addSubview(overlayView)

overlayView.frame = CGRect(origin: CGPoint.zero,
                           size: CGSize(width: 20, height: 10))
overlayView.resetAnchorPoint()
let start = Perspective(overlayView.frame)
let points = [
    CGPoint(x: 108.315837, y: 80.1687782),
    CGPoint(x: 377.282671, y: 41.4352201),
    CGPoint(x: 193.321418, y: 330.023027),
    CGPoint(x: 459.781253, y: 251.836131),
]
let destination = Perspective(points)

for (index, point) in points.enumerated() {
    let anchor = CGRect(origin: point, size: CGSize(width: 2, height: 2))
    let anchorView = UIView(frame: anchor)
    anchorView.backgroundColor = .yellow
    let label = UILabel(frame: CGRect(origin: point, size: CGSize(width: 40, height: 20)))
    label.text = String(index)
    label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    label.textColor = .green
    containerView.addSubview(label)
    containerView.addSubview(anchorView)
        UIView.animate(withDuration: 0.5 / Double(index + 1), delay: 0, options: [.repeat, .autoreverse], animations: {
            anchorView.alpha = 0
        }) { _ in
            anchorView.alpha = 1
        }
    label.center = anchorView.center
}

let transform = start.projectiveTransform(destination: destination)

let frames = 3.0
let durationOfEach = 1.0 / frames
var startTime = 0.0
UIView.animateKeyframes(withDuration: 2, delay: 0, options: [.autoreverse, .repeat], animations: {
    UIView.addKeyframe(withRelativeStartTime: startTime, relativeDuration: durationOfEach) {
        overlayView.layer.transform = transform.translateComponent
    }
    startTime += durationOfEach
    UIView.addKeyframe(withRelativeStartTime: startTime, relativeDuration: durationOfEach) {
        overlayView.layer.transform = transform.translateAndScale
    }
    startTime += durationOfEach
    UIView.addKeyframe(withRelativeStartTime: startTime, relativeDuration: durationOfEach) {
        overlayView.layer.transform = transform
    }
}, completion: nil)

print(transform)
transform.m13 == 0
transform.m23 == 0
transform.m31 == 0
transform.m32 == 0
transform.m34 == 0
transform.m43 == 0

transform.m33 == 1
transform.m44 == 1

transform.m41.rounded() == points[0].x.rounded()
transform.m42 == points[0].y
transform.m43 == 0
transform.m44 == 1

transform.m11.isEqual(to: 16.6798123042149)
print(transform.m11)
print(transform.m11.rounded())
print(transform.m11.rounded(FloatingPointRoundingRule.towardZero))
transform.m11.magnitude
transform.m11.magnitude.isEqual(to: CGFloat(16.6798123042149).magnitude)
transform.m11.significand.isEqual(to: CGFloat(16.6798123042149).significand)
transform.m11.significand
//: [Next](@next)
