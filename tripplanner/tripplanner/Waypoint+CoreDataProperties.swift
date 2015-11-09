//
//  Waypoint+CoreDataProperties.swift
//  tripplanner
//
//  Created by Jeroen Ransijn on 08/11/15.
//  Copyright © 2015 JeroenRansijn. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Waypoint {

    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var name: String?
    @NSManaged var trip: Trip?

}
