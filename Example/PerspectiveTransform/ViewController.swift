//
//  ViewController.swift
//  PerspectiveTransform
//
//  Created by Paul Zabelin on 02/18/2016.
//  Copyright (c) 2016 Paul Zabelin. All rights reserved.
//

import UIKit
import QuartzCore

@testable import PerspectiveTransform

class ViewController: UIViewController {


  @IBOutlet var cornerViews: [UIView]!
    @IBOutlet weak var transView: UIView!
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var destView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
      self.transView.frame = self.destView.frame
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updatePosition()
    }

    func updatePosition() {
        let centers = cornerViews.map{$0.center}
        let quad = Quadrilateral(centers)
        let start = Quadrilateral(startView.frame)
        let projection = general2DProjection(start, to: quad)
        let expanded = expandNoZ(expandNoZ(projection))
        let transform3D = transform(expanded)

        self.transView.layer.transform = transform3D
    }

  @IBAction func didPan(recognizer: UIPanGestureRecognizer) {
    let controlPoint = recognizer.view!
    let translation = recognizer.translationInView(view)
    controlPoint.center = CGPoint(x: controlPoint.center.x + translation.x,
      y: controlPoint.center.y + translation.y)
    recognizer.setTranslation(CGPointZero, inView: view)
    updatePosition()

  }

}

