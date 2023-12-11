//
//  PapagoModel.swift
//  DallETest
//
//  Created by 김태은 on 12/5/23.
//

import Foundation

struct PapagoModel: Decodable {
    var message: Message
    
    struct Message: Decodable {
        var result: Result
        
        struct Result: Decodable {
            var srcLangType: String
            var tarLangType: String
            var translatedText: String
            var engineType: String
            
            init(srcLangType: String, tarLangType: String, translatedText: String, engineType: String) {
                self.srcLangType = srcLangType
                self.tarLangType = tarLangType
                self.translatedText = translatedText
                self.engineType = engineType
            }
        }
        
        init(result: Result) {
            self.result = result
        }
    }
    
    init(message: Message) {
        self.message = message
    }
}
