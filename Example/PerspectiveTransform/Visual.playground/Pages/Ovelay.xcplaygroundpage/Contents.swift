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

UIView.animate(withDuration:1.0,
               delay: 0,
               options: [.repeat, .autoreverse],
               animations: {
                overlayView.layer.transform = start.projectiveTransform(destination: destination)
},
               completion:nil)


//: [Next](@next)
