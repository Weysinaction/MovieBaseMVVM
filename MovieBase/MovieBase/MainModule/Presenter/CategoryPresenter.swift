// CategoryPresenter.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import UIKit

protocol MainViewProtocol: AnyObject {
    var filmTableView: UITableView { get set }
    func success()
    func failure(error: Error)
}

protocol MainViewPresenterProtocol: AnyObject {
    var films: [MoviesManagedObjects]? { get set }
    func getMovies()
    func tapOnTheFilm(film: MoviesManagedObjects)
}

/// CategoryPresenter-
final class CategoryPresenter: MainViewPresenterProtocol {
    // MARK: public properties

    var films: [MoviesManagedObjects]? = []

    // MARK: private properties

    private weak var view: MainViewProtocol?
    private let movieAPIService: MovieAPIServiceProtocol!
    private let dataStorageService: DataStorageServiceProtocol?
    private let router: RouterProtocol?
    private let apiURL = "https://api.themoviedb.org/3/movie/popular?api_key=23df17499c6157c62e263dc10faac033"

    // MARK: init

    init(
        view: MainViewProtocol,
        movieAPIService: MovieAPIServiceProtocol,
        router: RouterProtocol,
        dataStorageService: DataStorageServiceProtocol
    ) {
        self.view = view
        self.movieAPIService = movieAPIService
        self.router = router
        self.dataStorageService = dataStorageService
    }

    func tapOnTheFilm(film: MoviesManagedObjects) {
        router?.showDetail(film: film)
    }

    func getMovies() {
        let movies = dataStorageService?.getFilms()
        guard let isEmpty = movies?.isEmpty else { return }
        if isEmpty {
            movieAPIService.getMovies { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case let .success(films):
                        self.dataStorageService?.addFilms(object: films ?? [])
                        let films = self.dataStorageService?.getFilms()
                        self.films = films
                        self.view?.success()
                    case let .failure(error):
                        self.view?.failure(error: error)
                    }
                }
            }
        } else {
            films = movies
            view?.success()
        }
    }
}
