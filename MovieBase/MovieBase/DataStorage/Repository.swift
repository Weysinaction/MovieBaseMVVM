// Repository.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

protocol DataBaseProtocol {
    func getFilms() -> [MoviesManagedObjects]?
    func addFilms(films: [Film])
    func deleteAllData(_ entity: String)
}

final class Repository: DataBaseProtocol {
    // MARK: private properties

    private let database: DataBaseProtocol!

    // MARK: init

    init(database: DataBaseProtocol) {
        self.database = database
    }

    // MARK: public methods

    func getFilms() -> [MoviesManagedObjects]? {
        database.getFilms()
    }

    func addFilms(films: [Film]) {
        database.addFilms(films: films)
    }

    func deleteAllData(_ entity: String) {
        database.deleteAllData(entity)
    }
}
