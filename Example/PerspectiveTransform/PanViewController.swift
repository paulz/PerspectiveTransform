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

extension UIPanGestureRecognizer {
    func panView() {
        let controlPoint = view!
        let pan = translation(in: controlPoint.superview)
        let transform = CGAffineTransform(translationX: pan.x, y: pan.y)
        controlPoint.center = controlPoint.center.applying(transform)
        setTranslation(CGPoint.zero, in:controlPoint.superview)
    }
}

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
        recognizer.panView()
        updatePosition()
    }

    // MARK: - private

    var startingPerspective : Perspective!

    func anchorAtZeroPoint() {
        transView.resetAnchorPoint()
        startingPerspective = Perspective(transView.frame)
    }

    func updatePosition() {
        let destination = Perspective(cornerViews.map{$0.center})
        transView.layer.transform = startingPerspective.projectiveTransform(destination: destination)
    }
}

