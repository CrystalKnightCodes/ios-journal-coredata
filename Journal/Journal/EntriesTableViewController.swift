//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Christy Hicks on 12/4/19.
//  Copyright © 2019 Knight Night. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
    // MARK: - Properties
    let entryController = EntryController()
    
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath) as? EntryTableViewCell else { fatalError() }
        let entry = entryController.entries[indexPath.row]
        cell.entry = entry
    
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            entryController.delete(entry: entryController.entries[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addEntrySegue" {
            let addVC = segue.destination as! EntryViewController
            addVC.entryController = entryController
        } else if segue.identifier == "viewEntrySegue" {
            let viewVC = segue.destination as! EntryViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
            viewVC.entryController = entryController
            viewVC.entry = entryController.entries[indexPath.row]
            }
        }
    }
}
