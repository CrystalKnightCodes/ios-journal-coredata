//
//  EntryViewController.swift
//  Journal
//
//  Created by Christy Hicks on 12/4/19.
//  Copyright © 2019 Knight Night. All rights reserved.
//

import UIKit

enum Mood: String, CaseIterable {
    case happy = "🙂"
    case neutral = "😐"
    case sad = "🙁"
}

class EntryViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var moodSC: UISegmentedControl!
    
    // MARK: - Properties
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        title = entry?.title ?? "Add Journal Entry"
        titleTextField.text = entry?.title
        
        let moodString = entry?.mood
        switch moodString {
        case Mood.happy.rawValue:
            moodSC.selectedSegmentIndex = 0
        case Mood.sad.rawValue:
            moodSC.selectedSegmentIndex = 2
        default:
            moodSC.selectedSegmentIndex = 1
        }
        
        detailTextView.text = entry?.detail
    }
    
    // MARK: - Actions
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text, !title.isEmpty,
            let detail = detailTextView.text, !detail.isEmpty else { return }
        let moodIndex = moodSC.selectedSegmentIndex
        let newMood = Mood.allCases[moodIndex]
        if let entry = entry {
            entryController?.update(entry: entry, title: title, mood: newMood.rawValue, detail: detail)
        } else {
            entryController?.create(title: title, mood: newMood.rawValue, detail: detail)
        }
        navigationController?.popViewController(animated: true)
    }
}
