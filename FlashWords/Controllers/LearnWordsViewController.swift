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
    func loadWords() {
        categoryLabel.text = sendCategory?.name
        
        categoryCount.text = String("\(words.actualWord+1) of \(words.getFreshWords().count)")
        wordLabel.text = words.getFreshWords()[words.actualWord].word
        contextLabel.text = words.getFreshWords()[words.actualWord].context
    }
    
    @IBAction func swipeDown(_ sender: UISwipeGestureRecognizer) {
        wordLabel.text = words.getFreshWords()[words.actualWord].word_t
    }
    
    
        
}
