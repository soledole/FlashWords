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
    var drawArray = [Int]()
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryCount: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var contextLabel: UILabel!
    @IBOutlet var swipeDown: UISwipeGestureRecognizer!
    
    //Arrows
    @IBOutlet weak var leftArrow: UIView!
    @IBOutlet weak var rightArrow: UIView!
    @IBOutlet weak var downArrow: UIView!
    
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
            //Set up draw
            for i in 0...wordQuantity-1 {
                drawArray.append(i)
            }
            if testVersion == true { print("drawArray: \(drawArray)") }
            loadWords()
        } else {
            noMoreWords()
        }
    }
    func loadWords() {
        showArrows(position: 1)
        chosenWord = drawArray.randomElement()!
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
                //For future update
//                try! realm.write {
//                    filterById.setValue(false, forKey: "fresh")
//                    filterById.setValue(false, forKey: "hard")
//                }
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
                //For future update
//                try! realm.write {
//                    filterById.setValue(false, forKey: "fresh")
//                    filterById.setValue(true, forKey: "hard")
//                }
                if testVersion == true {
                    print("---Save-wrong answere---")
                    print("\(i) Word: \(wrongWords[i])")
                    print("Filter: \(filterById)")
                }
            }
        }
    }
    
    func showArrows(position: Int) {
        //0 - all hidden, 1 - only down, 2- only left and right
        if position == 0 {
            leftArrow.isHidden = true
            rightArrow.isHidden = true
            downArrow.isHidden = true
        } else if position == 1 {
            leftArrow.isHidden = true
            rightArrow.isHidden = true
            downArrow.isHidden = false
        } else if position == 2 {
            leftArrow.isHidden = false
            rightArrow.isHidden = false
            downArrow.isHidden = true
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
        showArrows(position: 0)
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
    @IBAction func swipeDown(_ sender: UISwipeGestureRecognizer) {
        wordLabel.text = wordResults?[chosenWord].word_t
        checked = true
        showArrows(position: 2)
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
                if testVersion == true { print("Array before delate: \(drawArray), Word to Delate: \(chosenWord)") }
                drawArray = drawArray.filter(){$0 != chosenWord}
                if testVersion == true { print("Array after delate: \(drawArray)") }
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
                if testVersion == true { print("Array before delate: \(drawArray), Word to Delate: \(chosenWord)") }
                drawArray = drawArray.filter(){$0 != chosenWord}
                if testVersion == true { print("Array after delate: \(drawArray)") }
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
