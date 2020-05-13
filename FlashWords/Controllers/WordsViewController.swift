//
//  WordsViewController.swift
//  FlashWords
//
//  Created by Jędrzej Kuś on 04/05/2020.
//  Copyright © 2020 Jędrzej Kuś. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class WordsViewController: UITableViewController {
    
    //Initialize Realm and wordResults
    let realm = try! Realm()
    var wordResults : Results<Word>?
    
    var selectedCategory : Category? {
        didSet {
            loadWords()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Close keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordResults?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordsCell", for: indexPath) as! SwipeTableViewCell
        if let word = wordResults?[indexPath.row] {
            
            cell.textLabel?.text = word.word
            cell.detailTextLabel?.text = word.word_t
        } else {
            cell.textLabel?.text = "No words yet"
            cell.detailTextLabel?.text = "-"
        }
        cell.delegate = self
        return cell
    }
    
    //MARK: - Data Manipulation Methods
    func loadWords() {
        //wordResults = realm.objects(Word.self) //To show all items
        wordResults = selectedCategory?.words.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    //MARK: - TableView Delegate Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! AddWordsViewController
        destinationVC.sendCategory = selectedCategory
        destinationVC.instanceOfAdd = self
    }
    
    //MARK: - Add New Methods
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "goToAddWord", sender: self)
    }
}

//MARK: - Swipe Cell Delegate Methods
extension WordsViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            if let wordForDeletion = self.wordResults?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(wordForDeletion)
                    }
                } catch {
                    print("Error deleting category, \(error)")
                }
                tableView.reloadData()
            }
        }
        // customize the action appearance
        //deleteAction.image = UIImage(named: "delete_icon")
        return [deleteAction]
    }
}

//MARK: - Search Bar Methods
extension WordsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        wordResults = wordResults?.filter("word_t CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadWords()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

