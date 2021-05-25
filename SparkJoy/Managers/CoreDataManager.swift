//
//  CoreDataManager.swift
//  SparkJoy
//
//  Created by Max on 5/25/21.
//
// Referenced from https://www.youtube.com/watch?v=_ui7pxU1rNI&ab_channel=azamsharp

import Foundation
import CoreData

class CoreDataManager:ObservableObject {
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "ItemModel")
        persistentContainer.loadPersistentStores{(description, error) in if let error = error {
            fatalError("Core Data Store failed \(error.localizedDescription)")
        }}
    }
    
    func saveItem(title: String, desc: String, location: String, value: Float, category: Int16) {
        let item = Item(context: persistentContainer.viewContext)
        item.uid = UUID().uuidString
        item.title = title
        item.desc = desc
        item.location = location
        item.value = value
        item.category = category
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to save movie \(error)")
        }
    }
    
    func getAllItems() -> [Item] {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    func getItemByCategory(category: Int16) -> [Item] {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "category == %@", String(category))
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
}
