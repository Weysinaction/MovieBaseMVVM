// DataStorageService.swift
// Copyright © RoadMap. All rights reserved.

import CoreData
import Foundation

protocol DataStorageServiceProtocol {
    var repository: DataBaseProtocol! { get set }
    func getFilms() -> [MoviesManagedObjects]?
    func addFilms(object: [Film])
    func deleteAllData(_ entity: String)
}

/// DataStorageService-
class DataStorageService: DataStorageServiceProtocol {
    // MARK: internal properties

    internal var repository: DataBaseProtocol!

    // MARK: init

    init(repository: DataBaseProtocol) {
        self.repository = repository
    }

    // MARK: public methods

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
