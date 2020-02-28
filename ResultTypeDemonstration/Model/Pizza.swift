//
//  Pizza.swift
//  Created 2/28/20
//  Using Swift 5.0
// 
//  Copyright © 2020 Yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//


import Foundation

struct Pizza: Decodable {
    let name: String
    let price: Float
}

extension Array where Element == Pizza {
    init(file: URL) throws {
        let data = try Data(contentsOf: file)
        let decoder = JSONDecoder()
        self = try decoder.decode([Pizza].self, from: data)
    }
}
