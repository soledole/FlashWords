//
//  Word.swift
//  FlashWords
//
//  Created by Jędrzej Kuś on 04/05/2020.
//  Copyright © 2020 Jędrzej Kuś. All rights reserved.
//

import Foundation
import RealmSwift

class Word: Object {
    @objc dynamic var word : String = ""
    @objc dynamic var word_t : String = ""
    @objc dynamic var context : String = ""
    @objc dynamic var dateCreated : Date?
    @objc dynamic var fresh : Bool = true
    @objc dynamic var hard : Bool = false
    @objc dynamic var toRepeat : Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "words")
}
