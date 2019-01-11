//
//  TableViewController.swift
//  CoreDataExample
//
//  Created by Nathan Hancock on 1/10/19.
//  Copyright © 2019 NateHancock. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    var items: [NSManagedObject]?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        items = CoreDataManager.shared.load()
        tableView.reloadData()
    }
}

extension TableViewController {
    
    func addItem(with text: String) {
        
        if items == nil {
            items = []
        }
        
        if let addedObject = CoreDataManager.shared.save(name: text) {
            items!.append(addedObject)
            tableView.reloadData()
        }
    }
    
    func sortItems() {
        print("Need to implement!")
    }
}

// MARK: TableViewController Delegate
extension TableViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Key.Cell.tableView, for: indexPath) as! TableViewCell

        cell.titleLabel.text = item.value(forKey: Key.Jedi.name) as? String
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = items else {
            return 0
        }
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = items![indexPath.row]
            if CoreDataManager.shared.delete(object: item) {
                items!.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}

// MARK: Actions
extension TableViewController {
    @IBAction func didSelectAdd(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Available Actions", message: nil, preferredStyle: .actionSheet)
        
        let addAction = UIAlertAction(title: "Add Jedi", style: .default) { [unowned self] (action) in
            self.presentAddAlert()
        }
        
        let sortAction = UIAlertAction(title: "Sort", style: .default) { (action) in
            self.sortItems()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(sortAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: Alert Controllers
extension TableViewController {
    
    func presentAddAlert() {
        let alertController = UIAlertController(title: "Add new Jedi", message: nil, preferredStyle: .alert)
        
        alertController.addTextField()
        let closeAction = UIAlertAction.init(title: "Close", style: .destructive, handler: nil)
        alertController.addAction(closeAction)
        
        let addAction = UIAlertAction.init(title: "Add", style: .default) { [unowned self] (alertAction) in
            guard let textField = alertController.textFields?.first, let text = textField.text else {
                return
            }
            self.addItem(with: text)
        }
        alertController.addAction(addAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
