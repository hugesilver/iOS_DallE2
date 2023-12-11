//
//  DallEModel.swift
//  DallETest
//
//  Created by 김태은 on 12/5/23.
//

import Foundation

struct DallEModel: Decodable {
    var data: Array<Data>
    
    struct Data: Hashable, Decodable {
        var url: String
        
        init(url: String) {
            self.url = url
        }
    }
    
    init(data: Array<Data>) {
        self.data = data
    }
}
