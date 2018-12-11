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
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //MARK - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
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
        
        saveItemArray()
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
            
            self.saveItemArray()
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Load Data
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
    
    //MARK - Save and reload Data
    func saveItemArray() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        self.tableView.reloadData()
    }
}
