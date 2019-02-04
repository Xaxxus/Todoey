//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Brent Mifsud on 2018-12-09.
//  Copyright © 2018 Brent Mifsud. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    //MARK: - Global Variables and Constants
    var items : Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self        
    }
    
    //MARK: - Table View Setup and Logic
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //MARK: Get Number of Rows In Section
        return items?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //MARK: Get Cell For Row At
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListItem", for: indexPath)
        
        if let item = items?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //MARK: Row Selected Handler
        if let item = items?[indexPath.row]{
            do {
                try realm.write{
                    item.done = !item.done
                }
            } catch {
                print("Error updating done status: \(error)")
            }
        }
        
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let item = items?[indexPath.row]{
                deleteItem(item: item)
            }
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //MARK: Add Button Pressed Handler
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add To Do Item", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let currentCategory = self.selectedCategory{
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
               } catch {
                    print("Error saving new items: \(error)")
               }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (newTextField) in
            newTextField.placeholder = "example: Get Milk"
            textField = newTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - CRUD Operations on CoreData Table
    func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func deleteItem(item: Item) {
        do{
            try realm.write{
                realm.delete(item)
            }
        }catch{
            print("Error deleting item: \(error)")
        }
        
        tableView.reloadData()
    }
}

//MARK: - Search bar delegate
extension TodoListViewController: UISearchBarDelegate {   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            items = items?.filter(NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)).sorted(byKeyPath: "dateCreated", ascending: true)
            
            tableView.reloadData()
        } else {
            loadItems()
        }
    }
}
