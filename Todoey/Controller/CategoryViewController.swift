//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Brent Mifsud on 2019-01-27.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.categoryName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteCategory(category: categoryArray[indexPath.row])
            categoryArray.remove(at: indexPath.row)
            createUpdateCategories()
        }
    }

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
            let newItem = Category(context: self.context)
            newItem.categoryName = textField.text!
            self.categoryArray.append(newItem)
            self.createUpdateCategories()
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do{
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func createUpdateCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        self.tableView.reloadData()
    }
    
    func deleteCategory(category: Category) {
        context.delete(category)
    }
    
}
