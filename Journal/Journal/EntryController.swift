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
    private let baseURL = URL(string: "https://ios-journal-dd938.firebaseio.com")!
    
    typealias CompletionHandler = (Error?) -> Void
    
    //MARK: - Methods
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            guard error == nil else {
                print("Error fetching entries: \(error!)")
                completion(error)
                return
            }
            
            guard let data = data else {
                print("No data returned by data task.")
                completion(NSError())
                return
            }
            
            do {
                let entryRepresentations = Array(try JSONDecoder().decode([String : EntryRepresentation].self, from: data).values)
                
                try self.updateEntries(with: entryRepresentations)
                
                completion(nil)
            } catch {
                print("Error decoding entry representations: \(error)")
            }
        }.resume()
    }
    
    func put(entry: Entry, completion: @ escaping () -> Void = { } ) {
        let uuid = entry.identifier ?? UUID().uuidString
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard var representation = entry.entryRepresentation else {
                completion()
                return
            }
            
            representation.identifier = uuid
            entry.identifier = uuid
            try saveToPersistentStore()
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding entry \(entry): \(error)")
            completion()
            return
        }
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error ==  nil else {
                print("Error puting entry to server: \(error!)")
                completion()
                return
            }
            completion()
        }.resume()
    }
    
    func deleteEntryFromServer(_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = entry.identifier else {
            completion(NSError())
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            guard error == nil else {
                print("Error deleting task: \(error!)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    private func saveToPersistentStore() throws {
        let moc = CoreDataStack.shared.mainContext
        try moc.save()
    }
    
    func create(title: String, mood: String, detail: String?) {
        let entry = Entry(title: title, mood: mood, detail: detail, timeStamp: formatTime())
        put(entry: entry)
    }
    
    func update(entry: Entry, title: String, mood: String, detail: String?) {
        entry.title = title
        entry.mood = mood
        entry.detail = detail
        entry.timeStamp = formatTime()
        put(entry: entry)
    }
    
    private func updateEntries(with representations: [EntryRepresentation]) throws {
        let entriesWithID = representations.filter { $0.identifier != nil }
        let identifiersToFetch = entriesWithID.compactMap { UUID(uuidString: $0.identifier) }
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, entriesWithID))
        
        
        var entriesToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let context = CoreDataStack.shared.mainContext
        
        do {
            let existingEntries = try context.fetch(fetchRequest)
            
            for entry in existingEntries {
                guard let id = UUID(uuidString: entry.identifier!),
                    let representation = representationsByID[id] else {
                        let moc = CoreDataStack.shared.mainContext
                        moc.delete(entry)
                        continue
                }
                
                entry.title = representation.title
                entry.detail = representation.detail
                entry.mood = representation.mood
                entry.timeStamp = representation.timeStamp
                
                entriesToCreate.removeValue(forKey: id)
            }
            
            for representation in entriesToCreate.values {
                Entry(entryRepresentation: representation, context: context)
            }
        } catch {
            print ("Error fetching entries for UUIDs: \(error)")
        }
        
        try saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        deleteEntryFromServer(entry)
    }
    
    func formatTime() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        let formattedDate = formatter.string(from: date)
        return formattedDate
    }
}





