//
//  ViewController.swift
//  FlashWords
//
//  Created by Jędrzej Kuś on 29/04/2020.
//  Copyright © 2020 Jędrzej Kuś. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    //Initialize Realm and categories
    let realm = try! Realm()
    var categories : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.rowHeight = 100.0
        
        //Show Realm Database Path
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        return cell
    }
    
    //Swipe Cell
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //Delete Category
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, nil) in
            
            let alert = UIAlertController(title: "Delete Category", message: "Are you sure about it?", preferredStyle: .alert)
            let action = UIAlertAction(title: "Delete", style: .default) { (action) in
                
                if let categoryForDeletion = self.categories?[indexPath.row] {
                    do {
                        try self.realm.write {
                            self.realm.delete(categoryForDeletion)
                        }
                    } catch {
                        print("Error deleting category, \(error)")
                    }
                    tableView.reloadData()
                }
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion:{
                alert.view.superview?.isUserInteractionEnabled = true
                alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
            })
        }
        //Edit Category
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, nil) in
            
            var textField = UITextField()
            let alert = UIAlertController(title: "Edit Category", message: "If you do typo, you can change the name.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Edit", style: .default) { (action) in
                
                if textField.text!.isEmpty {
                    print("textField is empty")
                } else {
                    do {
                        try self.realm.write {
                            self.categories?[indexPath.row].setValue(textField.text, forKey: "name")
                        }
                    } catch {
                        print("Error changing category, \(error)")
                    }
                    tableView.reloadData()
                }
            }
            alert.addTextField { (alertTextField) in
                alertTextField.text = self.categories?[indexPath.row].name
                textField = alertTextField
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion:{
                alert.view.superview?.isUserInteractionEnabled = true
                alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
            })
        }
        deleteAction.image = UIImage(named: "delete_icon")
        editAction.image = UIImage(named: "edit_icon")
        editAction.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    @objc func dismissOnTapOutside(){
       dismiss(animated: true, completion: nil)
    }
    
    //MARK: - TableView Delegation Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToWords", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! WordsViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }

    }
    
    //MARK: - Data Manipulation Methods
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK: - Add New Category
    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            if textField.text!.isEmpty {
                print("textField is empty")
            } else {
                self.save(category: newCategory)
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter the name"
            textField = alertTextField
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion:{
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
        })
    }

    
}
