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
    
    //MARK: - Data Manipulation Methods
    func loadWords() {
        wordResults = selectedCategory?.words.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    //MARK: - TableView Delegate Methods
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "goToAddWord", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! AddWordsViewController
        destinationVC.sendCategory = selectedCategory
    }
    
    
}
