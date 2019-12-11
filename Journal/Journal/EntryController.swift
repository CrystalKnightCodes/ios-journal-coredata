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
    
    func delete(entry: Entry) {
//        let moc = CoreDataStack.shared.mainContext
//        moc.delete(entry)
//        do {
//            try moc.save()
//        } catch {
//            moc.reset()
//            print("Error saving managed object context \(error)")
//        }
        
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




 
