//
//  Translate.swift
//  FlashWords
//
//  Created by Jędrzej Kuś on 19/05/2020.
//  Copyright © 2020 Jędrzej Kuś. All rights reserved.
//

import Foundation

struct Translate {
    let langIn = "en"
    let langOut = "pol"
    let baseURL = "https://api.mymemory.translated.net/get"
    let apiKey = "D35D632E-A835-42CC-B990-73ACC181D985"
    
    func fetchTranslate(word: String) {
        let urlString = "\(baseURL)?q=\(word)&langpair=\(langIn)|\(langOut)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        print("urlString: \(urlString)")
        if let url = URL(string: urlString) {
            print("It should work")
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    let dataString = String(data: safeData, encoding: .utf8)
                    print(safeData)
                }
        }
        task.resume()
        } else {
            print("its not gonna work")
        }
    }
        
    
}
