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
    
    //Initialize Realm and Others
    let realm = try! Realm()
    var instanceOfEdit : WordsViewController!
    
    @IBOutlet weak var wordInput: UITextField!
    @IBOutlet weak var word_tInput: UITextField!
    @IBOutlet weak var contextInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.wordInput.delegate = self
        self.word_tInput.delegate = self
        self.contextInput.delegate = self
        
        loadData()
        
        //Close keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    //MARK: - Load Datasource Methods
    func loadData() {
        wordInput.text = ""
        word_tInput.text = ""
        contextInput.text = ""
    }
    //MARK: - Database Datasource Methods
    @IBAction func editButtonPressed(_ sender: UIButton) {

            do {
                try self.realm.write {
                    //Here will be code to update Realm
                    instanceOfEdit.tableView.reloadData()
                    dismiss(animated: true, completion: nil)
                }
            } catch {
                print("Error saving new word, \(error)")
            }
        
    }
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.switchBasedNextTextField(textField)
        return true
    }
    
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.word_tInput:
            self.wordInput.becomeFirstResponder()
        case self.wordInput:
            self.contextInput.becomeFirstResponder()
        default:
            self.contextInput.resignFirstResponder()
        }
    }
    
    
}
