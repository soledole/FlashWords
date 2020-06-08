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
    @IBOutlet var swipeDown: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryLabel.text = sendCategory?.name
        if words.checkNew() == false {
            wordLabel.text = "Done for today 😉"
            contextLabel.text = "You have to wait until tomorow for the next repeat."
            swipeDown.isEnabled = false
            return
        }
        loadWords()
    }
    
    //MARK: - TableView Delegation Methods
    @IBAction func goBackButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Data Manipulation Methods
    var lastWord = false
    var checked = false
    func loadWords() {
        categoryCount.text = String("\(words.actualWord+1) of \(words.getWords().count)")
        wordLabel.text = words.getWords()[words.actualWord].word
        contextLabel.text = words.getWords()[words.actualWord].context
    }
    func endRound() {
        swipeDown.isEnabled = false
        wordLabel.text = "END"
        contextLabel.text = "You've got \(words.right) good answer, and \(words.wrong) wrong."
        words.actualWord = 0
        words.right = 0
        words.wrong = 0
        words.setDate(forCategory: sendCategory!)
    }
    //Check the word translation
    @IBAction func swipeDown(_ sender: UISwipeGestureRecognizer) {
        wordLabel.text = words.getWords()[words.actualWord].word_t
        checked = true
        
        if words.getWords().count == words.actualWord+1 { lastWord = true ; print("lastWord") }
    }
    //If answere is right
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        if checked == true {
            print("YES")
            words.right += 1
            checked = false
            do {
                try realm.write {
                    words.getWords()[words.actualWord].setValue(false, forKey: "fresh")
                    words.getWords()[words.actualWord].setValue(false, forKey: "hard")
                }
            } catch {
                 print("Error changing word-hard, \(error)")
            }

            if lastWord == false {
                words.nextWord()
                loadWords()
            } else {
                print("Exit")
                endRound()
            }
            
        }
    }
    //If answere is wrong
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        if checked == true {
            print("NO")
            words.wrong += 1
            do {
                try realm.write {
                    words.getWords()[words.actualWord].setValue(false, forKey: "fresh")
                    words.getWords()[words.actualWord].setValue(true, forKey: "hard")
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
                endRound()
            }

        }
    }
    
}
