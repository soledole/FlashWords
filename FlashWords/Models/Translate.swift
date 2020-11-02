//
//  Translate.swift
//  FlashWords
//
//  Created by Jędrzej Kuś on 19/05/2020.
//  Copyright © 2020 Jędrzej Kuś. All rights reserved.
//

import Foundation
import MLKitTranslate
import RealmSwift

let realm = try! Realm()
var testVersion = true
let settings = realm.objects(Settings.self)

protocol TranslateDelegate {
    func didTranslate(translatedWord: String)
}

class Translate {
    var delegate: TranslateDelegate?
    
    let conditions = ModelDownloadConditions(
        allowsCellularAccess: true,
        allowsBackgroundDownloading: true
    )
    
    func fetchTranslate(for word: String) {
        let sourceLanguage = checkLanguages().0
        let targetLanguage = checkLanguages().1
        let langTranslator = downloadModel()
        
        langTranslator.translate(word) { translatedText, error in
            guard error == nil, let translatedText = translatedText else { return }
            if testVersion == true { print("\(sourceLanguage) > \(targetLanguage), \(word) > \(translatedText)")}
            self.delegate?.didTranslate(translatedWord: translatedText)
        }
    }
    
    func checkLanguages() -> (String, String) {
        let sourceLanguage = settings[0].sourceLanguage
        let targetLanguage = settings[0].targetLanguage
        return (sourceLanguage, targetLanguage)
    }
    
    func downloadModel() -> Translator {
        let sourceLanguage = checkLanguages().0
        let targetLanguage = checkLanguages().1
        
        let options = TranslatorOptions(sourceLanguage: TranslateLanguage(rawValue: sourceLanguage), targetLanguage: TranslateLanguage(rawValue: targetLanguage))
        let langTranslator = Translator.translator(options: options)
        
        langTranslator.downloadModelIfNeeded(with: conditions) { error in
            guard error == nil else { return }
        }
        return langTranslator
    }
    
}

