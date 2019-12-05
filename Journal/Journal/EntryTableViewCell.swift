//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Christy Hicks on 12/4/19.
//  Copyright © 2019 Knight Night. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    // MARK: - Properties
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Methods
    private func updateViews() {
        titleLabel.text = entry?.title
        timeLabel.text = "\(String(describing: entry?.timeStamp))"
        detailLabel.text = entry?.detail
    }
    
    

}
