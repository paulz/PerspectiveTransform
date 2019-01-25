//
//  PolygonLoader.swift
//  Example
//
//  Created by Paul Zabelin on 3/12/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

class PolygonLoader: NSObject {

    let parser: XMLParser

    init(fileName: String) {
        let bundle = Bundle(for: type(of: self))
        let name = fileName.split(separator: ".")
        let fileName: String = String(name.first!)
        let fileExtension: String = String(name.last!)
        let svgFileUrl = bundle.url(forResource: fileName, withExtension: fileExtension)!
        parser = XMLParser(contentsOf: svgFileUrl)!
        super.init()
        parser.delegate = self
    }

    func loadPoints() -> String {
        parser.parse()
        return pointString!
    }

    var pointString: String?
}

extension PolygonLoader: XMLParserDelegate {
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String: String] = [:]) {
        if elementName == "polygon" {
            pointString = attributeDict["points"]?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
}
