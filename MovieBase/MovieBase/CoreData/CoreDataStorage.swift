// CoreDataStorage.swift
// Copyright © RoadMap. All rights reserved.

import CoreData
import Foundation

final class CoreDataStorage: DataBaseProtocol {
    // MARK: private properties

    private let coreData = CoreDataService.shared

    // MARK: public methods

    func getFilms() -> [MoviesManagedObjects]? {
        let entityName = String(describing: MoviesManagedObjects.self)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let fetchObjects = try? coreData.context.fetch(fetchRequest) as? [MoviesManagedObjects]
        return fetchObjects
    }

    func addFilms(films: [Film]) {
        for element in films {
            let movie = MoviesManagedObjects(context: CoreDataService.shared.context)
            movie.posterPath = element.posterPath
            movie.overview = element.overview
            movie.originalTitle = element.originalTitle
            coreData.saveContext()
        }
    }

    func deleteAllData(_ entity: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try CoreDataService.shared.context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else { continue }
                CoreDataService.shared.context.delete(objectData)
                coreData.saveContext()
            }
        } catch {
            print("Delete all data in \(String(describing: MoviesManagedObjects.self)) error: \(error)")
        }
    }
}
