//: Animation to show tranformation of subview

//: open Playground timeline to see it

import UIKit
import PerspectiveTransform
import PlaygroundSupport

func viewWithFrame(origin: CGPoint = CGPoint.zero, size: CGSize) -> UIView {
    return UIView(frame: CGRect(origin: origin, size: size))
}

let page = PlaygroundPage.current
let containerView = viewWithFrame(size: CGSize(width: 300, height: 600))
containerView.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
page.liveView = containerView

let startView = viewWithFrame(size: CGSize(width: 150, height: 120))
startView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 0.501389954)

let destinationView = viewWithFrame(origin: CGPoint(x: 100, y: 100),
                                    size: CGSize(width: 200, height: 200))
destinationView.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 0.5081000767)

let view = viewWithFrame(size: CGSize(width: 150, height: 120))
view.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 0.5061709164)
view.resetAnchorPoint()

containerView.addSubview(startView)
containerView.addSubview(destinationView)
containerView.addSubview(view)

let start = Perspective(view.frame)
let transform = start.projectiveTransform(destination:Perspective(destinationView.frame))
print(transform)

UIView.animate(withDuration:1.0,
    delay: 0,
    options: [.repeat, .autoreverse],
    animations: {
        view.layer.transform = transform
    },
    completion: nil)
