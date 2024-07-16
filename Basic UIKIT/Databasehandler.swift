//
//  Databasehandler.swift
//  Basic UIKIT
//
//  Created by Amilzith on 17/07/24.
//

import UIKit
import CoreData

class Databasehandler: NSObject {
    static let shared = Databasehandler()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HomeData") // Replace "Model" with your data model file name
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteObject(withId id: Int64, completion: @escaping (Bool) -> Void) {
        
        let context = Databasehandler.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<HomeDataEntity> = HomeDataEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id=%d", id)
        
        do {
            let objects = try context.fetch(fetchRequest)
            guard let objectToDelete = objects.first else {
                completion(false)
                return
            }
            
            context.delete(objectToDelete)
            try context.save()
            completion(true)
        } catch {
            print("Error deleting object with id \(id):", error)
            completion(false)
        }
    }
    
    func fetchObject(withId id: Int64) -> HomeDataEntity? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<HomeDataEntity> = HomeDataEntity.fetchRequest()
        
        // Use %d for Int64
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let objects = try context.fetch(fetchRequest)
            return objects.first
        } catch {
            print("Error fetching object with id \(id):", error)
            return nil
        }
    }
}

