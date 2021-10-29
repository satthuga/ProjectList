//
//  ProjectList.swift
//  ProjectList
//
//  Created by Apple on 27/10/2021.
//

import Foundation

struct Project: Codable {
    var id: Int
    var name: String
}

struct Projects: Codable {
    var result: Int
    var projects: [Project]
}
