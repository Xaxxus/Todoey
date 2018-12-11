//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Brent Mifsud on 2018-12-09.
//  Copyright © 2018 Brent Mifsud. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListItem", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //MARK - Check or uncheck todo item
        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
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
            self.itemArray.append(textField.text!)
            self.tableView.reloadData()
        })
        
        present(alert, animated: true, completion: nil)
    }
}

