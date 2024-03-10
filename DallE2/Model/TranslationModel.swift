//
//  PapagoModel.swift
//  DallETest
//
//  Created by 김태은 on 12/5/23.
//

import Foundation

struct TranslationModel: Decodable {
    struct Choices: Decodable {
        let finish_reason: String
        let index: Int
        let message: Message
        let logprobs: String?
        
        struct Message: Decodable {
            let content: String
            let role: String
        }
    }
    
    let choices: [Choices]
    let created: Int
    let id: String
    let model: String
    let object: String
    
    struct Usage: Decodable {
        let completion_tokens: Int
        let prompt_tokens: Int
        let total_tokens: Int
    }
    
    let usage: Usage
    let system_fingerprint: String
}
