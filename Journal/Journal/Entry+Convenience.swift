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
    convenience init(title: String, detail: String? = nil, timeStamp: Date, identifier: String = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.detail = detail
        self.timeStamp = timeStamp
    }
}
