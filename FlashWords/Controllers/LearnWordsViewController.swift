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
    var wordQuantity = 0
    var actualWord = 0
    var chosenWord = 0
    var filter = 0
    let pickWordsByFilter = ["fresh", "hard"]
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
        startLearn()
    }
    
    //MARK: - TableView Delegation Methods
    @IBAction func goBackButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Main Methods
    func startLearn() {
        setWordResultForCategory()
        if filterWords() == true {
            if testVersion == true {
                print(wordResults!)
                print("filterSelected: \(pickWordsByFilter[filter])")
                print("wordQuantity: \(wordQuantity)")
            }
            loadWords()
        } else {
            noMoreWords()
        }
    }
    func loadWords() {
        chosenWord = checkNumber()
        categoryCount.text = "\(actualWord+1) of \(wordQuantity)"
        wordLabel.text = wordResults?[chosenWord].word
        contextLabel.text = wordResults?[chosenWord].context
        if testVersion == true {
            print("chosenWord: \(chosenWord)")
            print("actualWord: \(actualWord)")
        }
    }
    //MARK: - Secondary Methods
    func setWordResultForCategory() {
        wordResults = sendCategory?.words.sorted(byKeyPath: "dateCreated", ascending: true)
    }
    func filterWords() -> Bool {
        wordResults = wordResults!.filter("\(pickWordsByFilter[filter]) = true")
        wordQuantity = wordResults!.count
        if wordResults!.isEmpty {
            return false
        } else {
            return true
        }
    }
    func checkNumber() -> Int {
        return Int.random(in: 0..<wordQuantity)
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
        wordLabel.text = "End"
        contextLabel.text = "You've got \(right) good answer, and \(wrong) wrong."
        actualWord = 0
        right = 0
        wrong = 0
    }
    //MARK: - Data manipulation methods
    //Save data for right and wrong answer
    func saveIfRight() {
        do {
            try realm.write {
//                wordResults?[actualWord].setValue(false, forKey: pickWordsByFilter[0])
//                wordResults?[actualWord].setValue(false, forKey: pickWordsByFilter[1])
            }
        } catch {
            print("Error changing word status - \(pickWordsByFilter[1]), error: \(error)")
        }
    }
    func saveIfWrong() {
        do {
            try realm.write {
//                wordResults?[actualWord].setValue(false, forKey: pickWordsByFilter[0])
//                //wordResults?[actualWord].setValue(true, forKey: pickWordsByFilter[1])
            }
        } catch {
            print("Error changing word status - \(pickWordsByFilter[1]), error: \(error)")
        }
    }
    //Check the word translation
    @IBAction func swipeDown(_ sender: UISwipeGestureRecognizer) {
        wordLabel.text = wordResults?[chosenWord].word_t
        checked = true
        if wordQuantity == actualWord+1 {
            lastWord = true
            if testVersion == true { print("It will be the last word") }
        }
    }
    //If answere is right
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        if checked == true {
            right += 1
            checked = false
            
            if lastWord == false {
                saveIfRight()
                actualWord += 1
                if testVersion == true { print("---") }
                loadWords()
            } else {
                endRound()
                if testVersion == true { print("The end of a round") }
            }
        }
    }
    //If answere is wrong
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        if checked == true {
            wrong += 1
            checked = false
            
            if lastWord == false {
                saveIfWrong()
                actualWord += 1
                if testVersion == true { print("---") }
                loadWords()
            } else {
                endRound()
                if testVersion == true { print("The end of a round") }
            }
        }
    }
    
    
}
