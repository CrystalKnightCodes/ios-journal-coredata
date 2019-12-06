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
//            let entry = Entry(title: "Test", detail: "Detail", timeStamp: "This time")
//            return [entry]
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
        let newEntry = Entry(title: title, detail: detail, timeStamp: formatTime())
        entries.append(newEntry)
        saveToPersistentStore()
    }
    
    func update(entry: Entry, title: String, detail: String?) {
        entry.title = title
        entry.detail = detail
        entry.timeStamp = formatTime()
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        do {
            try moc.save()
        } catch {
            moc.reset()
            print("Error savingg managed object context \(error)")
        }
    }
    
    func formatTime() -> String {
        let date = Date() // 2018-10-10T10:00:00+00:00
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        let formattedDate: String = "\(month)/\(day)/\(year)  \(hour):\(minute)"
        return formattedDate
    }
}




 
