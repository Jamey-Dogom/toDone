//
//  CategoryViewController.swift
//  toDone
//
//  Created by Jamey Dogom on 8/27/19.
//  Copyright © 2019 Jamey Dogom. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    // initialize Realm, valid try according to Realm docs
    let realm = try! Realm()
    
    // ability to retreive data from DB
    //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // local array of category objects
    var categories: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCats()
    }
    
    //MARK: - TableView Datasource Methods
    // determine the number of rows necessary for the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // nil coalescing operator => check if nil and if it is do what is after ??
        return categories?.count ?? 1
        
    }
    // input data into the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            
            cell.textLabel?.text = category.name
            
//            guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
//
//            cell.backgroundColor = categoryColour
//            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
            
        }
        
        
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    
    
    
    //CRUD
    //MARK: - Data Manipulation Methods (Save & Load)
    
    // SAVE
    
    func saveCats(category : Category) {
        do {
            try realm.write {
                realm.add(category)
            }
            //            context.save()
        } catch {
            print("Error saving data, \(error)")
        }
    }
    
    func loadCats(){
        //        with request : NSFetchRequest<Category> = Category.fetchRequest()
        //        do {
        //            categories = try context.fetch(request)
        //        } catch {
        //            print("Error retreiving the data, \(error)")
        //        }
        categories = realm.objects(Category.self)
        //
        tableView.reloadData()
    }
    
    
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCat = Category()
            newCat.name = textField.text!
            //            self.categories.append(newCat)
            self.saveCats(category: newCat)
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
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
    
    
}
