//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Brent Mifsud on 2018-12-09.
//  Copyright © 2018 Brent Mifsud. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    //MARK: - Global Variables and Constants
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        searchBar.delegate = self
        
        loadItems()
    }
    
    //MARK: - Table View Setup and Logic
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //MARK: Get Number of Rows In Section
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //MARK: Get Cell For Row At
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListItem", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //MARK: Row Selected Handler
        let item = itemArray[indexPath.row]
        item.done = !item.done
        tableView.deselectRow(at: indexPath, animated: true)
        createUpdateItems()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteItem(item: itemArray[indexPath.row])
            itemArray.remove(at: indexPath.row)
            createUpdateItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //MARK: Add Button Pressed Handler
        var textField = UITextField()
        let alert = UIAlertController(title: "Add To Do Item", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (newTextField) in
            newTextField.placeholder = "example: Get Milk"
            textField = newTextField
        }
        
        alert.addAction(UIAlertAction(title: "Add Item", style: .default)
        {(action) in
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            self.createUpdateItems()
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - CRUD Operations on CoreData Table
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do{
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func createUpdateItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        self.tableView.reloadData()
    }
    
    func deleteItem(item: Item) {
        context.delete(item)
    }
}

//MARK: - Search bar delegate
extension TodoListViewController: UISearchBarDelegate {   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            let request: NSFetchRequest<Item> = Item.fetchRequest()
            
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadItems(with: request)
        }else{
            loadItems()
        }
    }
}
