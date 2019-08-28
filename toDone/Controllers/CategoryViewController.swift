//
//  CategoryViewController.swift
//  toDone
//
//  Created by Jamey Dogom on 8/27/19.
//  Copyright © 2019 Jamey Dogom. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    // ability to retreive data from DB
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // local array of category objects
    var categories = [Category]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCats()
    }

    //MARK: - TableView Datasource Methods
    // determine the number of rows necessary for the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    // input data into the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // upon scroll have the cells be reusable
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        // finding the category
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
     //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    
    
    
    
    //CRUD
    //MARK: - Data Manipulation Methods (Save & Load)
    
    // SAVE
    
    func saveCats() {
        do {
            try context.save()
        } catch {
            print("Error saving data, \(error)")
        }
    }
    
    func loadCats(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error retreiving the data, \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCat = Category(context: self.context)
            newCat.name = textField.text!
            self.categories.append(newCat)
            self.saveCats()
            self.loadCats()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        // add the action to the UI alert
        alert.addAction(action)
        
        // present the alert
        present(alert, animated: true, completion: nil)
        
    }
    
 

}
