//
//  ViewController.swift
//  PerspectiveTransform
//
//  Created by Paul Zabelin on 02/18/2016.
//  Copyright (c) 2016 Paul Zabelin. All rights reserved.
//

import UIKit
import QuartzCore

import PerspectiveTransform

class PanViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet var cornerViews: [UIView]!
    @IBOutlet weak var transView: UIView!
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var destView: UIView!

    // MARK: - UIViewController

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if startingPerspective == nil {
            anchorAtZeroPoint()
        }
        updatePosition()
    }

    @IBAction func didPan(_ recognizer: UIPanGestureRecognizer) {
        let controlPoint = recognizer.view!
        let translation = recognizer.translation(in: controlPoint.superview)
        let transform = CGAffineTransform(translationX: translation.x, y: translation.y)
        controlPoint.center = controlPoint.center.applying(transform)
        recognizer.setTranslation(CGPoint.zero, in:controlPoint.superview)
        updatePosition()
    }

    // MARK: - private

    var startingPerspective : Perspective!

    func anchorAtZeroPoint() {
        let rect = transView.frame
        transView.layer.anchorPoint = CGPoint.zero
        transView.frame = rect
        startingPerspective = Perspective(transView.frame)
    }

    func updatePosition() {
        let centers = cornerViews.map{$0.center}
        transView.layer.transform = startingPerspective.projectiveTransform(destination: Perspective(centers))
    }
}

