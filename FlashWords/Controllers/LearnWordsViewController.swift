//
//  LearnWordsViewController.swift
//  FlashWords
//
//  Created by Jędrzej Kuś on 25/05/2020.
//  Copyright © 2020 Jędrzej Kuś. All rights reserved.
//

import UIKit

class LearnWordsViewController: UIViewController {
    
    //Initialize Realm and Others
    var sendCategory : Category?
    
    @IBOutlet weak var categoryLabel: UILabel!
    
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
    }
    
        
}
