// MainPresenterTest.swift
// Copyright © RoadMap. All rights reserved.

@testable import MovieBase
import XCTest
/// MockView-
class MockView: MainViewProtocol {
    var filmTableView: UITableView

    func success() {}

    func failure(error: Error) {}

    init(tableView: UITableView) {
        filmTableView = tableView
    }
}

/// MockNetworkService-
class MockNetworkService: MovieAPIServiceProtocol {
    var films: [Film]! = []

    init() {}

    convenience init(films: [Film]?) {
        self.init()
        self.films = films
    }

    func getMovies(completion: @escaping (Result<[Film]?, Error>) -> Void) {
        if let films = films {
            completion(.success(films))
        } else {
            let error = NSError(domain: "network error", code: 0, userInfo: nil)
            completion(.failure(error))
        }
    }
}

/// MockDatabase-
class MockDatabase: DataBaseProtocol {
    var movies: [MoviesManagedObjects] = []
    func getFilms() -> [MoviesManagedObjects]? {
        movies
    }

    func addFilms(films: [Film]) {
        for element in films {
            let film = MoviesManagedObjects(context: CoreDataService.shared.context)
            film.overview = element.overview
            film.originalTitle = element.originalTitle
            film.posterPath = element.posterPath
            movies.append(film)
        }
    }

    func deleteAllData(_ entity: String) {
        movies = []
    }
}

/// MockDataStorage-
class MockDataStorage: DataStorageServiceProtocol {
    var repository: DataBaseProtocol!

    init(repository: DataBaseProtocol) {
        self.repository = repository
    }

    func getFilms() -> [MoviesManagedObjects]? {
        repository.getFilms()
    }

    func addFilms(object: [Film]) {
        repository.addFilms(films: object)
    }

    func deleteAllData(_ entity: String) {
        repository.deleteAllData(entity)
    }
}

/// MainPresenterTest-
class MainPresenterTest: XCTestCase {
    var view: MockView!
    var presenter: CategoryPresenter!
    var networkService: MovieAPIServiceProtocol!
    var router: RouterProtocol!
    var films: [Film] = []
    var dataStorage = MockDataStorage(repository: MockDatabase())

    override func setUpWithError() throws {
        let navController = UINavigationController()
        let assembly = AssemblyModel()
        router = Router(navigationController: navController, assemblyBuilder: assembly)
    }

    override func tearDownWithError() throws {
        view = nil
        networkService = nil
        presenter = nil
    }

    func testGetSuccessFilm() {
        let film = Film(posterPath: "/film/main/stub", overview: "overview", originalTitle: "original title")
        films.append(film)

        view = MockView(tableView: UITableView())
        networkService = MockNetworkService(films: films)

        presenter = CategoryPresenter(
            view: view,
            movieAPIService: networkService,
            router: router,
            dataStorageService: dataStorage
        )

        var catchFilms: [Film]?

        networkService.getMovies { result in
            switch result {
            case let .success(films):
                catchFilms = films
            case let .failure(error):
                print(error)
            }
        }

        XCTAssertNotEqual(catchFilms?.count, 0)
        XCTAssertEqual(catchFilms?.count, films.count)
    }

    func testGetFailureFilm() {
        view = MockView(tableView: UITableView())
        networkService = MockNetworkService(films: nil)
        presenter = CategoryPresenter(
            view: view,
            movieAPIService: networkService,
            router: router,
            dataStorageService: dataStorage
        )

        var catchError: Error?

        networkService.getMovies { result in
            switch result {
            case let .success(films):
                break
            case let .failure(error):
                catchError = error
            }
        }

        XCTAssertNotNil(catchError)
    }

    func testDataStorage() {
        let film = Film(posterPath: "/film/main/stub", overview: "overview", originalTitle: "original title")
        films.append(film)

        view = MockView(tableView: UITableView())
        networkService = MockNetworkService(films: films)
        presenter = CategoryPresenter(
            view: view,
            movieAPIService: networkService,
            router: router,
            dataStorageService: dataStorage
        )

        var optMovies = dataStorage.getFilms()
        guard let movies = optMovies else { return }
        if movies.isEmpty {
            networkService.getMovies { result in
                switch result {
                case let .success(films):
                    self.dataStorage.addFilms(object: films ?? [])
                    optMovies = self.dataStorage.getFilms()
                case let .failure(error):
                    print(error)
                }
            }
        }
        XCTAssertEqual(films[0].posterPath, optMovies?[0].posterPath)
    }
}
