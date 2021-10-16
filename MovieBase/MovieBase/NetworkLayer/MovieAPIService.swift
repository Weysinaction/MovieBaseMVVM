// MovieAPIService.swift
// Copyright © RoadMap. All rights reserved.

import Alamofire
import Foundation

protocol MovieAPIServiceProtocol {
    func getMovies(completion: @escaping (Result<[Film]?, Error>) -> Void)
}

/// MoviBaseService-
final class MovieAPIService: MovieAPIServiceProtocol {
    // MARK: private properties

    private let apiURL = "https://api.themoviedb.org/3/movie/popular?api_key=23df17499c6157c62e263dc10faac033"

    // MARK: public methods

    func getMovies(completion: @escaping (Result<[Film]?, Error>) -> Void) {
        AF.request(apiURL).responseData { response in
            guard let data = response.value else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let filmRequestModel = try decoder.decode(FilmRequestModel.self, from: data)

                guard let films = filmRequestModel.results else { return }
                completion(.success(films))

            } catch {
                completion(.failure(error))
            }
        }
    }
}
