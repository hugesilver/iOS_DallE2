//
//  DallEModel.swift
//  DallETest
//
//  Created by 김태은 on 12/5/23.
//

import Foundation

struct DallEModel: Decodable {
    let data: Array<Data>
    
    struct Data: Hashable, Decodable {
        let url: String
    }
}
