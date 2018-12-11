//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Brent Mifsud on 2018-12-09.
//  Copyright © 2018 Brent Mifsud. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListItem", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //MARK - Check or uncheck todo item
        let item = itemArray[indexPath.row]
        
        item.done = !item.done
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.tableView.reloadData()
    }
    
    //MARK - Add New To Do Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add To Do Item", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (newTextField) in
            newTextField.placeholder = "example: Get Milk"
            textField = newTextField
        }
        
        alert.addAction(UIAlertAction(title: "Add Item", style: .default)
        {(action) in
            
            let newItem = Item(Title: textField.text!, Done: false)
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
        })
        
        present(alert, animated: true, completion: nil)
    }
}

