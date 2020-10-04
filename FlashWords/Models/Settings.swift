//
//  Settings.swift
//  FlashWords
//
//  Created by Jędrzej Kuś on 04/10/2020.
//  Copyright © 2020 Jędrzej Kuś. All rights reserved.
//

import Foundation
import RealmSwift

class Settings: Object {
    @objc dynamic var firstTime : Bool = true
    @objc dynamic var sourceLanguage : String = ""
    @objc dynamic var targetLanguage : String = ""
}
