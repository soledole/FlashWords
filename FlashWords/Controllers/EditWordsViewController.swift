//
//  EditWordsViewController.swift
//  FlashWords
//
//  Created by Jędrzej Kuś on 14/05/2020.
//  Copyright © 2020 Jędrzej Kuś. All rights reserved.
//

import UIKit
import RealmSwift

class EditWordsViewController: UIViewController, UITextFieldDelegate {
    
    let realm = try! Realm()
    var sendWord : Word?
    var sendCell : Int?
    var instanceOfEdit : WordsViewController!
    var wordResults : Results<Word>?
    var translate = Translate()
    
    @IBOutlet weak var wordInput: UITextField!
    @IBOutlet weak var word_tInput: UITextField!
    @IBOutlet weak var contextInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.wordInput.delegate = self
        self.word_tInput.delegate = self
        self.contextInput.delegate = self
        translate.delegate = self
        
        loadData()
        //Close keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    //MARK: - Main Methods
    func loadData() {
        wordInput.text = sendWord?.word
        word_tInput.text = self.sendWord?.word_t
        contextInput.text = self.sendWord?.context
        wordResults = realm.objects(Word.self)
    }
    
    //MARK: - Database Datasource Methods
    @IBAction func editButtonPressed(_ sender: UIButton) {
         if wordInput.text!.isEmpty || word_tInput.text!.isEmpty {
            print("wordInput or word_tInput is empty")
         } else {
            do {
                try realm.write {
                    self.wordResults?[sendCell!].setValue(wordInput.text, forKey: "word")
                    self.wordResults?[sendCell!].setValue(word_tInput.text, forKey: "word_t")
                    self.wordResults?[sendCell!].setValue(contextInput.text, forKey: "context")
                    
                    instanceOfEdit.tableView.reloadData()
                    dismiss(animated: true, completion: nil)
                }
            } catch {
                print("Error changing word, \(error)")
            }
        }
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.switchBasedNextTextField(textField)
        return true
    }
    
    func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.wordInput:
            self.word_tInput.becomeFirstResponder()
        case self.word_tInput:
            self.contextInput.becomeFirstResponder()
        default:
            self.contextInput.resignFirstResponder()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == wordInput {
            if wordInput.text!.isEmpty {
            } else {
                let wordToTranslate = wordInput.text!
                translate.fetchTranslate(for: wordToTranslate)
            }
        }
    }
    
    
}

//MARK: - ML Kit Request
extension EditWordsViewController: TranslateDelegate {
    func didTranslate(translatedWord: String) {
        DispatchQueue.main.async {
            self.word_tInput.text = translatedWord
        }
    }
}
