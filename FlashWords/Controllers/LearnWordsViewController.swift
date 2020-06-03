//
//  LearnWordsViewController.swift
//  FlashWords
//
//  Created by Jędrzej Kuś on 25/05/2020.
//  Copyright © 2020 Jędrzej Kuś. All rights reserved.
//

import UIKit
import RealmSwift

class LearnWordsViewController: UIViewController {
    
    //Initialize Realm and Others
    let realm = try! Realm()
    var sendCategory : Category?
    var words = Words()
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryCount: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var contextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWords()
    }
    
    //MARK: - TableView Delegation Methods
    @IBAction func goBackButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Data Manipulation Methods
    var lastWord = false
    func loadWords() {
        categoryLabel.text = sendCategory?.name
        
        categoryCount.text = String("\(words.actualWord+1) of \(words.getFreshWords().count)")
        wordLabel.text = words.getFreshWords()[words.actualWord].word
        contextLabel.text = words.getFreshWords()[words.actualWord].context
    }
    
    var checked = false
    //Check the word translation
    @IBAction func swipeDown(_ sender: UISwipeGestureRecognizer) {
        wordLabel.text = words.getFreshWords()[words.actualWord].word_t
        checked = true
        
        if words.getFreshWords().count == words.actualWord+1 { lastWord = true }
    }
    //If answere is right
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        if checked == true {
            print("YES")
            do {
                try realm.write {
//                    words.getFreshWords()[words.actualWord].setValue(false, forKey: "fresh")
//                    words.getFreshWords()[words.actualWord].setValue(false, forKey: "hard")
                }
            } catch {
                 print("Error changing word-hard, \(error)")
            }
            
            checked = false
            if lastWord == false {
                words.nextWord()
                loadWords()
            } else {
                print("Exit")
            }
            
        }
    }
    //If answere is wrong
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        if checked == true {
            print("NO")
            do {
                try realm.write {
//                    words.getFreshWords()[words.actualWord].setValue(false, forKey: "fresh")
//                    words.getFreshWords()[words.actualWord].setValue(true, forKey: "hard")
                }
            } catch {
                 print("Error changing word-hard, \(error)")
            }
            
            checked = false
            if lastWord == false {
                words.nextWord()
                loadWords()
            } else {
                print("Exit")
            }
            
        }
    }
    
}
