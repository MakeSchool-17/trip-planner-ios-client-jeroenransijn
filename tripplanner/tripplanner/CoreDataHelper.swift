//
//  CoreDataHelper.swift
//  tripplanner
//
//  Created by Jeroen Ransijn on 08/11/15.
//  Copyright © 2015 JeroenRansijn. All rights reserved.
//

import Foundation
import CoreData

class CoreDataHelper {
    
    static let singleInstance = CoreDataHelper()
    
    static let managedObjectContext = CoreDataStack(stackType: .SQLite).managedObjectContext
    
    static private func saveContext() {
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    static func saveTrip(name: String) {
        let trip: Trip = NSEntityDescription.insertNewObjectForEntityForName("Trip", inManagedObjectContext: managedObjectContext) as! Trip
        
        trip.name = name
        
        saveContext()
    }
    
    static func deleteTrip(trip: Trip) {
        managedObjectContext.deleteObject(trip)
        saveContext()
    }
    
    static func allTrips() -> [Trip] {
        let fetchRequest = NSFetchRequest(entityName: "Trip")
        
        var result = [Trip]()
        
        do {
            result = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Trip]
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return result
    }
    
    static func saveWaypoint(trip: Trip, latitude: Float, longitude: Float, name: String) {
        let waypoint: Waypoint = NSEntityDescription.insertNewObjectForEntityForName("Waypoint", inManagedObjectContext: managedObjectContext) as! Waypoint
        
        print("saveWaypoint called")
        
        waypoint.name = name
        waypoint.longitude = longitude
        waypoint.latitude = latitude
        waypoint.trip = trip
        
        saveContext()
    }
    
    static func deleteWaypoint(waypoint: Waypoint) {
        managedObjectContext.deleteObject(waypoint)
        saveContext()
    }
    
    static func allWaypoints(trip: Trip) -> [Waypoint] {
        let fetchRequest = NSFetchRequest(entityName: "Waypoint")
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "trip", trip)
        
        var result = [Waypoint]()
        
        do {
            result = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Waypoint]
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return result
    }
    
}
