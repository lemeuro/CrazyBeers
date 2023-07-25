//
//  Beer.swift
//  CrazyBeers
//
//  Created by Lem Euro on 21/07/2023.
//

import Foundation

struct Beer: Codable, Identifiable {
    let id: Int
    let name: String
    let tagline: String
    let image_url: String
}
