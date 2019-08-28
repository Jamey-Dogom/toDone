//
//  ViewController.swift
//  toDone
//
//  Created by Jamey Dogom on 8/26/19.
//  Copyright © 2019 Jamey Dogom. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    // an array of Item objects
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
//         self.loadItems()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
        // file manager, which is an object which provides an interface to to the file share manager
        // default, shared, singleton
        
        
//        if let items = defaults.array(forKey: "ToDoArray") as? [Item] {
//            itemArray = items
//        }
        // Do any additional setup after loading the view.
    }
    
    //MARK - Tableview Datasource Methods
    
    // display how many number of rows in the table view controller
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // inputting data into each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    // create tableview delegate methods that gets fired when a cell is clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        // add a checkmark to the selected item
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        self.saveItems()
//        self.loadItems()
        // reload the table
        self.loadItems()
        tableView.reloadData()
        
        // have the gray highlight of the selected cell go away
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    // ui alert or popup to allow text input
    // which then appends that data to the end of the array
        
        var textField = UITextField()
    
        let alert = UIAlertController(title: "Add New toDone Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen when user clicks the action
            
           
            // inside closure
            // create new item as instance of data model
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()
           
            
//            self.loadItems()
            // reload the information
            self.tableView.reloadData()
        }
        
        // add an input textfield to the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        // add the action to the UI alert
        alert.addAction(action)
        
        // present the alert
        present(alert, animated: true, completion: nil)
        
    }
    
    // C CREAT ITEMS
    func saveItems() {
//        let encoder = PropertyListEncoder()
        do {
            try context.save()
//            let data = try encoder.encode(self.itemArray)
//            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error saving data, \(error)")
        }
    }
    
    // R Read Items
    // set default parameter as request all items
    // external parameter -> with, internal parameter -> request
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
//        if let data = try? Data(contentsOf: dataFilePath!){
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
         request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, categoryPredicate])
        } else {
             request.predicate = categoryPredicate
        }
            
        
        
         do {
            itemArray = try context.fetch(request)
//            itemArray = try decoder.decode([Item].self, from: data)
         } catch {
            print("Error reading items from Persitence Container, \(error)")
        }
        
        tableView.reloadData()
      }
    
   
    
    
    }

// extends controller and allows for search bar delegate
//MARK: - Search bar methods
extension ToDoListViewController : UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        // queuery the DB
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        // NS predicate
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        loadItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       if searchBar.text?.count == 0 {
            loadItems()
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
        }
    }
}

