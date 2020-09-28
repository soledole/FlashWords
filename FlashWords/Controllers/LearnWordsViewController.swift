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
    var rightWords = [String]()
    var wrongWords = [String]()
    
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
    func createRightArray() {
        rightWords.append((wordResults?[chosenWord].id)!)
    }
    func createWrongArray() {
        wrongWords.append((wordResults?[chosenWord].id)!)
    }
    func saveData() {
        if right > 0 {
            for i in 0...rightWords.count-1 {
                let filterById = realm.objects(Word.self).filter("id = %@", "\(rightWords[i])")
                try! realm.write {
                    filterById.setValue(false, forKey: "hard")
                }
                if testVersion == true {
                    print("---Save-right answere---")
                    print("\(i) Word: \(rightWords[i])")
                    print("Filter: \(filterById)")
                }
            }
        }
        if wrong > 0 {
            for i in 0...wrongWords.count-1 {
                let filterById = realm.objects(Word.self).filter("id = %@", "\(wrongWords[i])")
                try! realm.write {
                    filterById.setValue(true, forKey: "hard")
                }
                if testVersion == true {
                    print("---Save-wrong answere---")
                    print("\(i) Word: \(wrongWords[i])")
                    print("Filter: \(filterById)")
                }
            }
        }
    }
    //MARK: - Endings
    func noMoreWords() {
        categoryCount.text = ""
        wordLabel.text = "Done for today 😉"
        contextLabel.text = "You have to wait until tomorow for the next repeat."
        return
    }
    func endRound() {
        if testVersion == true {
            print("\(right) right answere's: \(rightWords)")
            print("\(wrong) wrong answere's: \(wrongWords)")
        }
        swipeDown.isEnabled = false
        wordLabel.text = "End"
        contextLabel.text = "You've got \(right) good answer, and \(wrong) wrong."
        saveData()
        actualWord = 0
        right = 0
        wrong = 0
    }
    //MARK: - Swiping methods
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
                createRightArray()
                actualWord += 1
                if testVersion == true { print("---") }
                loadWords()
            } else {
                createRightArray()
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
                createWrongArray()
                actualWord += 1
                if testVersion == true { print("---") }
                loadWords()
            } else {
                createWrongArray()
                endRound()
                if testVersion == true { print("The end of a round") }
            }
        }
    }
    
    
}
