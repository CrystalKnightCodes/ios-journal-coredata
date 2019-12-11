//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Christy Hicks on 12/10/19.
//  Copyright © 2019 Knight Night. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    let title: String
    let mood: String?
    let detail: String?
    let timeStamp: String
    let identifier: String
}
