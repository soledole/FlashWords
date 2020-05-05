//
//  AddWordsViewController.swift
//  FlashWords
//
//  Created by Jędrzej Kuś on 04/05/2020.
//  Copyright © 2020 Jędrzej Kuś. All rights reserved.
//

import UIKit
import RealmSwift

class AddWordsViewController: UIViewController {
    
    //Initialize Realm
    let realm = try! Realm()
    var sendCategory : Category?

    @IBOutlet weak var wordInput: UITextField!
    @IBOutlet weak var word_tInput: UITextField!
    @IBOutlet weak var contextInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Database Datasource Methods
    @IBAction func addButtonPressed(_ sender: UIButton) {
        if let currentCategory = self.sendCategory {
            do {
                try self.realm.write {
                    let newWord = Word()
                    newWord.word = wordInput.text!
                    newWord.word_t = word_tInput.text!
                    newWord.context = contextInput.text!
                    newWord.dateCreated = Date()
                    
                    currentCategory.words.append(newWord)
                    self.dismiss(animated: true, completion: {
                        let parentVC = WordsViewController() //To check
                        print("parentVC: \(parentVC)")
                        parentVC.tableView.reloadData()
                    })
                }
            } catch {
                print("Error saving new word, \(error)")
            }
        }
        
    }
    
    
}
