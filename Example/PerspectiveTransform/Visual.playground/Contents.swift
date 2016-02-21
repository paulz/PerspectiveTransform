//: Playground - noun: a place where people can play

import UIKit
import PerspectiveTransform
import XCPlayground

let page = XCPlaygroundPage.currentPage
let containerView = UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 300, height: 600)))
containerView.backgroundColor = [#Color(colorLiteralRed: 0.9019607902, green: 0.9019607902, blue: 0.9019607902, alpha: 1)#]
page.liveView = containerView

let startView = UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 150, height: 120)))
startView.backgroundColor = [#Color(colorLiteralRed: 0.4980392157, green: 1, blue: 0.4274509804, alpha: 0.5071790541)#]

let destinationView = UIView(frame: CGRect(origin: CGPoint(x: 100, y: 100), size: CGSize(width: 200, height: 200)))
destinationView.backgroundColor = [#Color(colorLiteralRed: 0.8000000119, green: 0.400000006, blue: 1, alpha: 0.5365815033783784)#]

let view = UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 150, height: 120)))
view.backgroundColor = [#Color(colorLiteralRed: 0, green: 0.501960814, blue: 0.501960814, alpha: 0.5085779138513513)#]
view.resetAnchorPoint()

containerView.addSubview(startView)
containerView.addSubview(destinationView)
containerView.addSubview(view)

let quad = Quadrilateral(view.frame)
let transform = quad.projectiveTransform(Quadrilateral(destinationView.frame))

UIView.animateWithDuration(1.0,
    delay: 0,
    options: [.Repeat, .Autoreverse],
    animations: {
        view.layer.transform = transform
    },
    completion: nil)
