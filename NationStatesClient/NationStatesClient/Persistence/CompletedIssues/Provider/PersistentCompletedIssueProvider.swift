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
    
    var persistentContainer: NSPersistentContainer?
    
    init(nationName: String) {
        self.setup(for: nationName)
    }
    
    func setup(for nationName: String) {
        guard let modelURL = Bundle.main.url(forResource: "CompletedIssuesModel", withExtension: "momd"),
              let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
        else { return }
        
        // By passing the container name and managedObjectModel seperately, we can use the default store location without the need for FileManager calls.
        // This should also make sure every signed in nation gets their own datastore.
        self.persistentContainer = NSPersistentContainer(name: "\(nationName.lowercased()).sqlite",
                                              managedObjectModel: managedObjectModel)
        
        self.persistentContainer?.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func fetchCompletedIssues() -> AnyPublisher<[CompletedIssue], Error> {
        guard let container = self.persistentContainer else { return Just([]).mapError { _ -> Error in }.eraseToAnyPublisher() }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CompletedIssue")
        
        do {
            let result = try container.viewContext.fetch(fetchRequest)
            
            let results = result.compactMap({ ($0 as? CompletedIssueMO)?.completedIssue })
            return Just(results).mapError { _ -> Error in }.eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    func storeCompletedIssue(_ completed: CompletedIssue) {
        guard let container = self.persistentContainer else { return }
        container.viewContext.insert(CompletedIssueMO(with: completed, context: container.viewContext))
        self.saveContext()
    }
}

private extension PersisentCompletedIssueProvider {
    // MARK: - Core Data Saving support
    
    func saveContext () {
        guard let container = self.persistentContainer else { return }
        
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
