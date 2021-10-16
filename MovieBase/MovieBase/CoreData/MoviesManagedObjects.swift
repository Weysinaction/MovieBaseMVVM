// MoviesManagedObjects.swift
// Copyright © RoadMap. All rights reserved.

import CoreData
import Foundation

/// MoviesManagedObjects-
@objc(MoviesManagedObjects)

final class MoviesManagedObjects: NSManagedObject {
    @NSManaged var posterPath: String?
    @NSManaged var overview: String?
    @NSManaged var originalTitle: String?
}
