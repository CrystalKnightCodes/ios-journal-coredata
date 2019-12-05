//
//  EntryController.swift
//  Journal
//
//  Created by Christy Hicks on 12/4/19.
//  Copyright © 2019 Knight Night. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    // MARK: - Properties
    var entries: [Entry] {
        get {
            loadFromPersistentStore()
        }
        set {
            saveToPersistentStore()
        }
    }
    
    //MARK: - Methods
    func saveToPersistentStore() {
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            print("Error fetching tasks: \(error)")
            return []
        }
    }
    
    func create(title: String, detail: String?) {
        let timeStamp = Date()
        let newEntry = Entry(title: title, detail: detail, timeStamp: timeStamp)
        entries.append(newEntry)
        saveToPersistentStore()
    }
    
    func update(newTitle: String, newDetail: String?, index: Int) {
        entries.remove(at: index)
        let timeStamp = Date()
        let updatedEntry = Entry(title: newTitle, detail: newDetail, timeStamp: timeStamp)
        entries.insert(updatedEntry, at: index)
        saveToPersistentStore()
    }
    
    func delete(index: Int) {
        entries.remove(at: index)
        saveToPersistentStore()
    }
}
