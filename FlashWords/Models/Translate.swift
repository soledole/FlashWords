//
//  Translate.swift
//  FlashWords
//
//  Created by Jędrzej Kuś on 19/05/2020.
//  Copyright © 2020 Jędrzej Kuś. All rights reserved.
//

import Foundation
import Firebase

let options = TranslatorOptions(sourceLanguage: .en, targetLanguage: .pl)
let englishPolishTranslator = NaturalLanguage.naturalLanguage().translator(options: options)

let conditions = ModelDownloadConditions(
    allowsCellularAccess: false,
    allowsBackgroundDownloading: false
)

protocol TranslateDelegate {
    func didTranslate(translatedWord: String)
}

struct Translate {
    
    var delegate: TranslateDelegate?
    
    func fetchTranslate(for word: String) {
        englishPolishTranslator.downloadModelIfNeeded(with: conditions) { error in
            guard error == nil else { return }
            print("You already downloaded successfully language model.")
        }
        
        englishPolishTranslator.translate(word) { translatedText, error in
            guard error == nil, let translatedText = translatedText else { return }

            print("Translated Word: \(translatedText)")
            self.delegate?.didTranslate(translatedWord: translatedText)
        }
    }
    
}
