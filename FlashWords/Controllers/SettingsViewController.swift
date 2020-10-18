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
    
    @IBOutlet weak var languagePickView: UIPickerView!
    var languages = ["polish", "english", "deutsh", "french", "spain"]
    var languagesRawValue = ["pl", "en", "de", "fr", "es"]
    var sourceLangSelected: String?
    var targetLangSelected: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languagePickView.dataSource = self
        languagePickView.delegate = self
    }
//MARK: - UI Elements
    
//MARK: - Main methods
    
//MARK: - Secondary Methods
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
    }
}
