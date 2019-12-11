//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Christy Hicks on 12/10/19.
//  Copyright © 2019 Knight Night. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var title: String
    var mood: String?
    var detail: String?
    var timeStamp: String
    var identifier: String
}
