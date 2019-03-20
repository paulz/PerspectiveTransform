//
//  PhotoViewController.swift
//  Example
//
//  Created by Paul Zabelin on 1/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import PerspectiveTransform
import ImageCoordinateSpace

class PhotoViewController: UIViewController {

    @IBOutlet var containerImageView: UIImageView!
    @IBOutlet var overlayImageView: UIImageView!
    var fitApplied = false
    var reverseApplied = false
    var transform: CATransform3D!

    @IBOutlet weak var fittingView: UIView!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        containerImageView.resetAnchorPoint()
        containerImageView.frame = containerImageView.bounds
        overlayImageView.resetAnchorPoint()
        overlayImageView.frame = overlayImageView.bounds
    }

    @IBAction func didSelectSegment(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.5) {
            if sender.selectedSegmentIndex == 1 {
                self.toggleReverse()
            } else {
                self.toggleTransform()
            }
        }
    }

    func toggleReverse() {
        reverseApplied = !reverseApplied
        fitApplied = false
        containerImageView.layer.transform = reverseApplied ? reverseTranformation() : CATransform3DIdentity
        overlayImageView.layer.transform = CATransform3DIdentity
    }

    func toggleTransform() {
        fitApplied = !fitApplied
        reverseApplied = false
        overlayImageView.layer.transform = fitApplied ? toFitImageTranformation() : CATransform3DIdentity
        containerImageView.layer.transform = CATransform3DIdentity
    }

    lazy var iPadPerspective: Perspective = {
        let polygon = FittingPolygon.load(fromSvgFile: "with-overlay.svg")
        let points = polygon.points.map {
            self.containerImageView.contentSpace().convert($0, to: self.view)
        }
        return Perspective(points)
    }()

    func toFitImageTranformation() -> CATransform3D {
        let start = Perspective(overlayImageView.bounds)
        return start.projectiveTransform(destination: iPadPerspective)
    }

    func reverseTranformation() -> CATransform3D {
        let destination = Perspective(fittingView.frame)
        return iPadPerspective.projectiveTransform(destination: destination)
    }

}
