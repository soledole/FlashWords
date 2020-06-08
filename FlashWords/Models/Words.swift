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
    var right = 0
    var wrong = 0
    
    func checkNew() -> Bool {
        let Words = realm.objects(Word.self).filter("fresh = true")
        if Words.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    func getWords() -> Results<Word> {
        let Words = realm.objects(Word.self)
        return Words
    }
    
    mutating func nextWord() {
        actualWord += 1
    }
    
    func setDate(forCategory: Object) {
        do {
            try realm.write {
                forCategory.setValue(Date(), forKey: "dateLearn")
            }
        } catch {
            print("Error setting date, \(error)")
        }
    }
}
