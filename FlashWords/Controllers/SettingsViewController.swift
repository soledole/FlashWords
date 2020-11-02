//
//  SettingsViewController.swift
//  FlashWords
//
//  Created by Jędrzej Kuś on 04/10/2020.
//  Copyright © 2020 Jędrzej Kuś. All rights reserved.
//

import UIKit
//import MLKitTranslate

class SettingsViewController: UIViewController {
    
    var languages = ["polish", "english", "deutsh", "french", "spain"]
    var languagesRawValue = ["pl", "en", "de", "fr", "es"]
    var sourceLangSelected: String?
    var targetLangSelected: String?
    
    @IBOutlet weak var languagePickView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languagePickView.dataSource = self
        languagePickView.delegate = self
        loadPickerPosition()
    }
    
//MARK: - Main Methods
    func loadPickerPosition() {
        let sourceLanguage = Translate().checkLanguages().0
        let targetLanguage = Translate().checkLanguages().1
        var sourcePosition: Int
        var targetPosition: Int
        
        switch sourceLanguage {
        case "pl":
            sourcePosition = 0
        case "en":
            sourcePosition = 1
        case "de":
            sourcePosition = 2
        case "fr":
            sourcePosition = 3
        case "es":
            sourcePosition = 4
        default:
            sourcePosition = 1
        }
        
        switch targetLanguage {
        case "pl":
            targetPosition = 0
        case "en":
            targetPosition = 1
        case "de":
            targetPosition = 2
        case "fr":
            targetPosition = 3
        case "es":
            targetPosition = 4
        default:
            targetPosition = 0
        }
        
        languagePickView.selectRow(sourcePosition, inComponent: 0, animated: true)
        languagePickView.selectRow(targetPosition, inComponent: 1, animated: true)
    }
//    func getModelLanguages(){
//        let languagesArray = ["pl", "en", "de", "fr", "it"]
//        var localModel = String(ModelManager.modelManager().downloadedTranslateModels.description)
//        localModel = String(localModel.dropFirst())
//        localModel = String(localModel.dropLast())
//        let parts = localModel.components(separatedBy: ",")
//        for i in 0...parts.count-1 {
//            for lang in languagesArray {
//                if lang == parts[i].suffix(2) {
//                    print("Found \(lang) for index \(i)")
//                    break
//                }
//            }
//        }
//    }

    
}
//MARK: - UI Elements
extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var row = pickerView.selectedRow(inComponent: 0)
        sourceLangSelected = languagesRawValue[row]
        
        row = pickerView.selectedRow(inComponent: 1)
        targetLangSelected = languagesRawValue[row]
        
        let settings = realm.objects(Settings.self)
        try! realm.write {
            settings.setValue(sourceLangSelected, forKey: "sourceLanguage")
            settings.setValue(targetLangSelected, forKey: "targetLanguage")
        }
        Translate().downloadModel()
    }
}
