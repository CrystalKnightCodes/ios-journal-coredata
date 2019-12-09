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
    convenience init(title: String, mood: String? = Mood.neutral.rawValue, detail: String? = nil, timeStamp: String, identifier: String = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.mood = mood
        self.detail = detail
        self.timeStamp = timeStamp
    }
}
