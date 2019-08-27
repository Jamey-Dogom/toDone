//
//  ViewController.swift
//  toDone
//
//  Created by Jamey Dogom on 8/26/19.
//  Copyright © 2019 Jamey Dogom. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    // an array of Item objects
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.loadItems()
        
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
        self.loadItems()
        // reload the table
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
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
            self.loadItems()
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
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!){
         let decoder = PropertyListDecoder()
         do {
            itemArray = try decoder.decode([Item].self, from: data)
         } catch {
            print("Error encoding item array, \(error)")
        }
      }
    
    }
}

