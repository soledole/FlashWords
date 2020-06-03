//
//  Words.swift
//  FlashWords
//
//  Created by Jędrzej Kuś on 01/06/2020.
//  Copyright © 2020 Jędrzej Kuś. All rights reserved.
//

import Foundation
import RealmSwift

struct Words {
    let realm = try! Realm()
    var actualWord = 0
    
    func getFreshWords() -> Results<Word> {
        let filteredWords = realm.objects(Word.self).filter("fresh = true")
        return filteredWords
    }
    
    mutating func nextWord() {
        actualWord += 1
    }
}
