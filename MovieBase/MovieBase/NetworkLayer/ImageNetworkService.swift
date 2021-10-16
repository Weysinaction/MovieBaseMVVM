// ImageNetworkService.swift
// Copyright © RoadMap. All rights reserved.

import Alamofire
import Foundation

protocol ImageNetworkServiceProtocol {
    func getImageFromPath(path: String, completion: @escaping (Data) -> Void)
}

/// ImageNetworkService-
final class ImageNetworkService: ImageNetworkServiceProtocol {
    // MARK: private properties

    private var url = "https://image.tmdb.org/t/p/w500"

    // MARK: internal methods

    internal func getImageFromPath(path: String, completion: @escaping (Data) -> Void) {
        AF.request("\(url)\(path)").responseData { response in
            guard let data = response.value else { return }
            completion(data)
        }
    }
}
