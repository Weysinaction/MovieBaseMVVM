// FilmRequestModel.swift
// Copyright © RoadMap. All rights reserved.

import CoreData
import Foundation

/// FilmRequestModel-
struct FilmRequestModel: Decodable {
    let page: Int?
    let results: [Film]?
}
