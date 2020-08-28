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
    var wordResults : Results<Word>?
    var testVersion = true
    var actualWord = 0
    var wordSelected = 0
    var checked = false
    var lastWord = false
    var right = 0
    var wrong = 0
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryCount: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var contextLabel: UILabel!
    @IBOutlet var swipeDown: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        categoryLabel.text = sendCategory?.name
        filterWords()
    }
    
    //MARK: - TableView Delegation Methods
    @IBAction func goBackButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    //MARK: - Main Methods
    func setWordResultForCategory(){
        wordResults = sendCategory?.words.sorted(byKeyPath: "dateCreated", ascending: true)
    }
    func resetCounter() {
         categoryCount.text = String("\(wordSelected+1) of \(wordResults!.count)")
    }
    func loadWords() {
        if testVersion == true { print("actualWord: \(actualWord)")}
        
        wordLabel.text = wordResults?[actualWord].word
        contextLabel.text = wordResults?[actualWord].context
        
        if testVersion == true { print(wordResults) }
    }
    
    //MARK: - Common states
    func checkToRepeat() -> Bool {
        wordResults = wordResults!.filter("toRepeat = true")
        if wordResults!.isEmpty {
            print("nothing to repeat")
            setWordResultForCategory()
            return false
        } else {
            print("there is something to repeat")
            return true
        }
    }
    func checkFresh() -> Bool {
        wordResults = wordResults!.filter("fresh = true")
        if wordResults!.isEmpty {
            print("nothing fresh")
            setWordResultForCategory()
            return false
        } else {
            print("there is something fresh")
            return true
        }
    }
    func checkHard() -> Bool {
        wordResults = wordResults!.filter("hard = true")
        if wordResults!.isEmpty {
            print("nothing hard")
            setWordResultForCategory()
            return false
        } else {
            print("there is something hard")
            return true
        }
    }
    //Choose one of them
    func filterWords() {
        setWordResultForCategory()
        if checkToRepeat() == true {
            print("run only with words to repeat")
            loadWords()
        }  else if checkFresh() == true {
            print("run only with fresh words")
            resetCounter()
            loadWords()
        } else if checkHard() == true {
            print("run only with hard words")
            loadWords()
        } else {
            print("nope")
            noMoreWords()
        }
        if testVersion == true { print("----------")}
    }
    
    //MARK: - Endings
    func noMoreWords() {
        categoryCount.text = ""
        wordLabel.text = "Done for today 😉"
        contextLabel.text = "You have to wait until tomorow for the next repeat."
        return
    }
    func endRound() {
        swipeDown.isEnabled = false
        wordLabel.text = "END"
        contextLabel.text = "You've got \(right) good answer, and \(wrong) wrong."
        actualWord = 0
        right = 0
        wrong = 0
        //filterWords() //-> To loop whole script
    }
    
    //MARK: - Data manipulation methods
    //Save data for right answere
    func saveIfRight() {
        do {
            try realm.write {
                wordResults?[actualWord].setValue(false, forKey: "fresh")
                wordResults?[actualWord].setValue(false, forKey: "hard")
            }
        } catch {
             print("Error changing word-hard, \(error)")
        }
    }
    func saveIfWrong() {
        do {
            try realm.write {
                wordResults?[actualWord].setValue(false, forKey: "fresh")
                wordResults?[actualWord].setValue(true, forKey: "hard")
            }
        } catch {
             print("Error changing word-hard, \(error)")
        }
    }
    //Check the word translation
    @IBAction func swipeDown(_ sender: UISwipeGestureRecognizer) {
        wordLabel.text = wordResults?[actualWord].word_t
        checked = true
        
        if wordResults?.count == actualWord+1 {
            lastWord = true
            print("It will be last word")
        }
    }
    //If answere is right
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        if testVersion == true { print("right swipe, checked: \(checked)") }
        if checked == true {
            print("YES")
            right += 1
            checked = false
            
            if lastWord == false {
                print("actual: \(actualWord)")
                saveIfRight()
                //actualWord += 1
                wordSelected += 1
                loadWords()
            } else {
                print("Exit")
                endRound()
            }
        }
    }
    //If answere is wrong
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        if testVersion == true { print("left swipe, checked: \(checked)")}
        if checked == true {
            wrong += 1
            checked = false
            
            if lastWord == false {
                actualWord += 1
                loadWords()
            } else {
                print("Exit")
                endRound()
            }
        }
    }
    
    
}
