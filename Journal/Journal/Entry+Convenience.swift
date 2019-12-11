//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Christy Hicks on 12/4/19.
//  Copyright © 2019 Knight Night. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
        let mood = mood,
        let timeStamp = timeStamp else {
            return nil
        }
        
        return EntryRepresentation(title: title, mood: mood, detail: detail, timeStamp: timeStamp, identifier: identifier ?? UUID().uuidString)
    }
    
    convenience init(title: String, mood: String? = Mood.neutral.rawValue, detail: String? = nil, timeStamp: String, identifier: String = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.mood = mood
        self.detail = detail
        self.timeStamp = timeStamp
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        let identifier = entryRepresentation.identifier
        guard let mood = entryRepresentation.mood
        else { return nil }
        
        self.init(title: entryRepresentation.title,
            mood: mood,
            detail: entryRepresentation.detail,
            timeStamp: entryRepresentation.timeStamp,
            identifier: identifier,
            context: context)
    }
}
