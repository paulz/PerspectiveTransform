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

    @IBOutlet weak var transView: UIView!
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var destView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transView.frame = startView.frame
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let start = Quadrilateral(startView.frame)
        let destination = Quadrilateral(destView.frame)
        let projection = general2DProjection(start, to: destination)
        let expanded = expandNoZ(expandNoZ(projection))
        let transform3D = transform(expanded)
//        self.transView.layer.anchorPoint = CGPointMake(100, 100)

        UIView.animateWithDuration(1.0) {
            self.transView.layer.transform = transform3D
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

