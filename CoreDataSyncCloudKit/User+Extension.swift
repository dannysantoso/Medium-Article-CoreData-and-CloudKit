//
//  User+Extension.swift
//  CoreDataSyncCloudKit
//
//  Created by danny santoso on 26/12/20.
//

import CoreData

extension User {
    // MARK: - Fetch Data
    static func fetchAll(viewContext: NSManagedObjectContext) -> [User] {
        
        let request: NSFetchRequest<User> = User.fetchRequest()
        let sectionSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        request.sortDescriptors = sortDescriptors
        
        guard let result = try? viewContext.fetch(request) else {
            return []
        }
        return result
    }
    
    static func fetchQuery(viewContext: NSManagedObjectContext, name: String, predicate: NSPredicate? = nil) -> [User] {
        let request: NSFetchRequest<User> = User.fetchRequest()
        
        let projectpredicate = NSPredicate(format: "name CONTAINS %@", name)
        
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [projectpredicate, addtionalPredicate])
        } else {
            request.predicate = projectpredicate
        }
        
        guard let result = try? viewContext.fetch(request) else {
            return []
        }
        return result
    }
    
    // MARK: - Save & Update Data
    static func save(viewContext: NSManagedObjectContext, image: Data, name: String, date: Date) -> User? {
        
        let user = User(context: viewContext)
        user.image = image
        user.name = name
        user.date = date
        
        do {
            try viewContext.save()
            return user
        } catch {
            return nil
        }
        
    }
    
    static func update(viewContext: NSManagedObjectContext, image: Data, name: String, date: Date, user: [User], index: Int) {
        
        user[index].image = image
        user[index].name = name
        user[index].date = date
        
        do {
            try viewContext.save()
        } catch {
            print("Error saving context \(error)")
        }
        
    }
    
    // MARK: - Delete Data
    static func delete(viewContext: NSManagedObjectContext, user: [User], index: Int) {
        viewContext.delete(user[index])
        do {
            try viewContext.save()
        } catch {
        }
    }
}
