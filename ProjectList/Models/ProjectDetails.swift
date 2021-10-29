//
//  ProjectDetails.swift
//  ProjectList
//
//  Created by Apple on 27/10/2021.
//

import Foundation

class Frame: Codable {
    var x : Double = 0
    var y: Double = 0
    var width: Double = 0
    var height: Double = 0
}

class Photo : Codable {
    var url: String = ""
    var frame: Frame = Frame()
    
    init(data: [String: Any]) {
        if let url = data["url"] as? String, let frame = data["frame"] as? [String: Double] {
                self.url = url
            
            if let x = frame["x"],let y = frame["y"],let width = frame["width"],let height = frame["height"] {
                self.frame.x = x
                self.frame.y = y
                self.frame.width = width
                self.frame.height = height
            }
            
        }
    }
    
    init() {
    }
}

extension Photo : Equatable {
    public static func ==(lhs: Photo, rhs: Photo) -> Bool {
            return lhs.url == rhs.url
        }
}
