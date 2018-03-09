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

class FittingPolygon {
    var points: [CGPoint] = []

    init(svgPointsString:String) {
        let formatter = NumberFormatter()
        let eightNumbers: [CGFloat] = svgPointsString.split(separator: " ").map { substring in
            let string = String(substring)
            let number = formatter.number(from: string)
            return CGFloat(truncating: number!)
        }
        for point in stride(from:0, to: 7, by: 2) {
            let x = eightNumbers[point]
            let y = eightNumbers[point + 1]
            points.append(CGPoint(x: x, y: y))
        }
        assert(points.count == 4, "should have 4 point")
        points = [points[3], points[0], points[2], points[1]]
        print("points:", points)
    }

    class func loadFromSvgFile() -> FittingPolygon {
        let loader = PolygonLoader(fileName: "with-overlay.svg")
        return loader.load()
    }
}

class PolygonLoader: NSObject {

    let svgFileUrl: URL

    init(fileName: String) {
        let bundle = Bundle(for: type(of: self))
        let name = fileName.split(separator: ".")
        let fileName: String = String(name.first!)
        let fileExtension: String = String(name.last!)
        svgFileUrl = bundle.url(forResource: fileName, withExtension: fileExtension)!
    }

    func load() -> FittingPolygon {
        let parser = XMLParser(contentsOf: svgFileUrl)!
        parser.delegate = self
        parser.parse()
        return FittingPolygon(svgPointsString: pointString!)
    }

    var pointString: String?
}

extension PolygonLoader: XMLParserDelegate {
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        if elementName == "polygon" {
            pointString = attributeDict["points"]?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
}

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
        overlayImageView.frame = overlayImageView.bounds
        overlayImageView.resetAnchorPoint()
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
