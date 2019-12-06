//
//  EntryViewController.swift
//  Journal
//
//  Created by Christy Hicks on 12/4/19.
//  Copyright © 2019 Knight Night. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    
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
        detailTextView.text = entry?.detail
    }
    
    // MARK: - Actions
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text, !title.isEmpty,
            let detail = detailTextView.text, !detail.isEmpty else { return }
        if let entry = entry {

            entryController?.update(entry: entry, title: title, detail: detail)
        } else {
            entryController?.create(title: title, detail: detail)
        }
        navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
