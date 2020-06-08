//
//  Category.swift
//  FlashWords
//
//  Created by Jędrzej Kuś on 30/04/2020.
//  Copyright © 2020 Jędrzej Kuś. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var dateLearn : Date?
    let words = List<Word>()
}
