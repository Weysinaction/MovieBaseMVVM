// AssemblyModel.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

protocol AssemblyBuilderProtocol {
    func createMain(router: RouterProtocol) -> UIViewController
    func createDetail(router: RouterProtocol, film: MoviesManagedObjects) -> UIViewController
}

/// ModuleBuilder-
final class AssemblyModel: AssemblyBuilderProtocol {
    func createMain(router: RouterProtocol) -> UIViewController {
        let movieAPIService = MovieAPIService()
        let view = CategoryViewController()
        let repository = Repository(database: CoreDataStorage())
        let dataStorageService = DataStorageService(repository: repository)
        let viewModel = CategoryViewModel(
            movieAPIService: movieAPIService,
            dataStorageService: dataStorageService
        )
        view.viewModel = viewModel
        view.router = router

        return view
    }

    func createDetail(router: RouterProtocol, film: MoviesManagedObjects) -> UIViewController {
        let networkService = ImageNetworkService()
        let view = ViewController()
        let presenter = DetailPresenter(view: view, film: film, networkService: networkService, router: router)
        view.presenter = presenter

        return view
    }
}
