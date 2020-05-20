//
//  AddWordsViewController.swift
//  FlashWords
//
//  Created by Jędrzej Kuś on 04/05/2020.
//  Copyright © 2020 Jędrzej Kuś. All rights reserved.
//

import UIKit
import RealmSwift

class AddWordsViewController: UIViewController, UITextFieldDelegate {
    
    //Initialize Realm and Others
    let realm = try! Realm()
    var sendCategory : Category?
    var instanceOfAdd : WordsViewController!
    var translate = Translate()

    @IBOutlet weak var wordInput: UITextField!
    @IBOutlet weak var word_tInput: UITextField!
    @IBOutlet weak var contextInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.wordInput.delegate = self
        self.word_tInput.delegate = self
        self.contextInput.delegate = self
        
        //Close keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
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
                    
                    if wordInput.text!.isEmpty || word_tInput.text!.isEmpty {
                        print("wordInput or word_tInput is empty")
                    } else {
                        currentCategory.words.append(newWord)
                        instanceOfAdd.tableView.reloadData()
                        dismiss(animated: true, completion: nil)
                    }
                }
            } catch {
                print("Error saving new word, \(error)")
            }
        }
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.switchBasedNextTextField(textField)
        return true
    }
    
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.wordInput:
            self.word_tInput.becomeFirstResponder()
        case self.word_tInput:
            self.contextInput.becomeFirstResponder()
        default:
            self.contextInput.resignFirstResponder()
        }
    }
    
    //MARK: - API Request
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let word = wordInput.text {
            translate.fetchTranslate(word: word)
        }
    }
    
    
}
