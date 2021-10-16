// CategoryViewModel.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import UIKit

protocol MainViewProtocol: AnyObject {
    var filmTableView: UITableView { get set }
}

protocol CategoryViewModelProtocol {
    var films: [MoviesManagedObjects]? { get set }
    func getMovies(completion: @escaping () -> ())
}

/// CategoryPresenter-
final class CategoryViewModel: CategoryViewModelProtocol {
    // MARK: public properties

    var films: [MoviesManagedObjects]? = []

    // MARK: private properties

    private let movieAPIService: MovieAPIServiceProtocol!
    private let dataStorageService: DataStorageServiceProtocol?
    private let apiURL = "https://api.themoviedb.org/3/movie/popular?api_key=23df17499c6157c62e263dc10faac033"

    // MARK: init

    init(
        movieAPIService: MovieAPIServiceProtocol,
        dataStorageService: DataStorageServiceProtocol
    ) {
        self.movieAPIService = movieAPIService
        self.dataStorageService = dataStorageService
    }

    func getMovies(completion: @escaping () -> ()) {
        let movies = dataStorageService?.getFilms()
        guard let isEmpty = movies?.isEmpty else { return }
        if isEmpty {
            movieAPIService.getMovies { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(films):
                    self.dataStorageService?.addFilms(object: films ?? [])
                    self.films = self.dataStorageService?.getFilms()
                    completion()
                case .failure:
                    break
                }
            }
        } else {
            films = movies
            completion()
        }
    }
}
