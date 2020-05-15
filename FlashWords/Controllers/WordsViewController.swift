//
//  WordsViewController.swift
//  FlashWords
//
//  Created by Jędrzej Kuś on 04/05/2020.
//  Copyright © 2020 Jędrzej Kuś. All rights reserved.
//

import UIKit
import RealmSwift

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
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordsCell", for: indexPath)
        if let word = wordResults?[indexPath.row] {
            
            cell.textLabel?.text = word.word
            cell.detailTextLabel?.text = word.word_t
        } else {
            cell.textLabel?.text = "No words yet"
            cell.detailTextLabel?.text = "-"
        }
        return cell
    }
    
    //SwipeCell
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //Delete Word
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, nil) in
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
        //Edit Word
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, nil) in
            self.performSegue(withIdentifier: "goToEditWord", sender: self)
        }
        editAction.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    //MARK: - TableView Delegate Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToAddWord") {
            let addWordsVC = segue.destination as! AddWordsViewController
            addWordsVC.sendCategory = selectedCategory
            addWordsVC.instanceOfAdd = self
        }
        if (segue.identifier == "goToEditWord") {
            let editWordsVC = segue.destination as! EditWordsViewController
            editWordsVC.instanceOfEdit = self
        }
    }
    
    //MARK: - Data Manipulation Methods
    func loadWords() {
        //wordResults = realm.objects(Word.self) //To show all items
        wordResults = selectedCategory?.words.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    //MARK: - Add New Word Methods
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "goToAddWord", sender: self)
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
