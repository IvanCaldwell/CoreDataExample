//
//  CoreDataManager.swift
//  CoreDataExample
//
//  Created by Nathan Hancock on 1/10/19.
//  Copyright © 2019 NateHancock. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        // 1. Fetch your container
        let container = NSPersistentContainer(name: "CoreDataExample")
        // 2. Load your stores
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            // A description or an error will be returned for each store loaded from the container
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //Helper variable to get the Managed Object Context
    private var managedContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

}

// MARK: Utility Methods
extension CoreDataManager {
    
    func load() -> [NSManagedObject]? {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Key.Jedi.rawValue)
        
        do {
            return try managedContext.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func save(name: String) -> NSManagedObject? {
        
        guard let entity = NSEntityDescription.entity(forEntityName: Key.Jedi.rawValue, in: managedContext) else {
            print("unable to find object")
            return nil
        }
        
        let todo = NSManagedObject(entity: entity, insertInto: managedContext)
        
        todo.setValue(name, forKey: Key.Jedi.name)
        
        do {
            try managedContext.save()
            return todo
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func delete(object: NSManagedObject) -> Bool {
        
        managedContext.delete(object)
        do {
            try managedContext.save()
            return true
        } catch let error {
            print(error.localizedDescription)
            return false
        }
    }
    
    func sortAlphabetically() -> [NSManagedObject]? {
        print("sortAlphabetically() - need to implement!")
        
        return nil
    }
    
    func saveContext () {
        // 1. get the viewContext from the persistentContainer
        let context = persistentContainer.viewContext
        
        // 2. Check if it has changes. Try to save if it does. Do nothing if it doesnt.
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print("Error: \(error.localizedDescription)")
            }
        }
        
        
        
    }
}
