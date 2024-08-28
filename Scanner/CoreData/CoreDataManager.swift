//
//  CoreDataManager.swift
//  Scanner
//
//  Created by Saurav on 28/08/24.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    // Singleton instance
    static let shared = CoreDataManager()
    
    // Reference to persistent container
    private let persistentContainer: NSPersistentContainer
    
    // Private initializer to ensure it's a singleton
    private init() {
        // Replace "YourProjectName" with the name of your .xcdatamodeld file
        persistentContainer = NSPersistentContainer(name: "Barcode")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }
    
    // Managed object context
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data Operations
    
    // Save context to persist changes
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // Create a new entity
    func createEntity<T: NSManagedObject>(ofType entityType: T.Type) -> T {
        let entityName = String(describing: entityType)
        guard let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? T else {
            fatalError("Unable to create entity of type \(entityName)")
        }
        return entity
    }
    
    // Fetch entities
    func fetchEntities<T: NSManagedObject>(ofType entityType: T.Type, withPredicate predicate: NSPredicate? = nil) -> [T] {
        let entityName = String(describing: entityType)
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.predicate = predicate
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch entities: \(error)")
            return []
        }
    }
    
    // Delete an entity
    func deleteEntity(_ entity: NSManagedObject) {
        context.delete(entity)
        saveContext()
    }
    
    // Delete all entities of a certain type
    func deleteAllEntities<T: NSManagedObject>(ofType entityType: T.Type) {
        let entities = fetchEntities(ofType: entityType)
        for entity in entities {
            context.delete(entity)
        }
        saveContext()
    }
}
