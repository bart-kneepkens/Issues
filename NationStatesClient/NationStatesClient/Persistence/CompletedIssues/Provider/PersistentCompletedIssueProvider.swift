//
//  PersistentCompletedIssueProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/11/2020.
//

import Foundation
import Combine
import CoreData

class PersisentCompletedIssueProvider: CompletedIssueProvider {
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "CompletedIssuesModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func fetchCompletedIssues() -> AnyPublisher<[CompletedIssue], APIError> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CompletedIssue")
        
        let result = try! self.persistentContainer.viewContext.fetch(fetchRequest)
        
        let results = result.map({ $0 as! CompletedIssueMO }).map({ $0.completedIssue })
        
        return Just(results).mapError { _ -> APIError in }.eraseToAnyPublisher()
    }
    
    func storeCompletedIssue(_ completed: CompletedIssue) {
//        self.persistentContainer.
        
        let managedObject = NSEntityDescription.insertNewObject(forEntityName: "CompletedIssue", into: self.persistentContainer.viewContext) as! CompletedIssueMO
        
        managedObject.configure(with: completed, context: self.persistentContainer.viewContext)
        
        self.saveContext()
    }
}

private extension PersisentCompletedIssueProvider {
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
