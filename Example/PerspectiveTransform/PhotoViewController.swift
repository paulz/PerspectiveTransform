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
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    var applied = false
    var transform: CATransform3D!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        toggleTransform()
    }

    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.5) {
            self.toggleTransform()
        }
    }

    func toggleTransform() {
        applied = !applied
        overlayImageView.layer.transform = applied ? CATransform3DIdentity : tranformation()
    }

    func tranformation() -> CATransform3D {
        overlayImageView.resetAnchorPoint()
        overlayImageView.frame = overlayImageView.bounds
        let start = Perspective(overlayImageView.frame)
        let transform = FittingPolygon.loadFromSvgFile()
        let points = transform.points.map {
            return containerImageView.contentSpace().convert($0, to: view)
        }
        let destination = Perspective(points)
        print("start:", start)
        print("destination:", destination)
        return start.projectiveTransform(destination: destination)
    }

    func applyTranformation() {
        overlayImageView.layer.transform = tranformation()
    }
}
