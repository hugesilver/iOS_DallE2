//
//  PapagoViewModel.swift
//  DallETest
//
//  Created by 김태은 on 12/5/23.
//

import Foundation

class PapagoViewModel: ObservableObject {
    var clientId: String {
        guard let plistPath = Bundle.main.path(forResource: "SecureKeys", ofType: "plist"),
              let plistDict = NSDictionary(contentsOfFile: plistPath) else {
            fatalError("SecureKeys.plist를 찾을 수 없어요.")
        }
        
        guard let value = plistDict["Papago_Client_ID"] as? String else {
            fatalError("Papago_Client_ID를 찾을 수 없어요.")
        }
        
        return value
    }
    
    var clientSecret: String {
        guard let plistPath = Bundle.main.path(forResource: "SecureKeys", ofType: "plist"),
              let plistDict = NSDictionary(contentsOfFile: plistPath) else {
            fatalError("SecureKeys.plist를 찾을 수 없어요.")
        }
        
        guard let value = plistDict["Papago_Client_Secret"] as? String else {
            fatalError("Papago_Client_Secret를 찾을 수 없어요.")
        }
        
        return value
    }
    
    func postPapago(prompt: String, completion: @escaping (PapagoModel?) -> Void) {
        var urlComponents = URLComponents(string: "https://openapi.naver.com/v1/papago/n2mt")!
        urlComponents.queryItems = [
            URLQueryItem(name: "source", value: "ko"),
            URLQueryItem(name: "target", value: "en"),
            URLQueryItem(name: "text", value: prompt)
        ]
        
        // Header 세팅
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue(clientId, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        // API 요청
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    // if let jsonString = String(data: data, encoding: .utf8) {
                    //     print("Received JSON data: \(jsonString)")
                    // }
                    
                    // PapagoModel JSON 디코드
                    let decoder = JSONDecoder()
                    let papagoModel = try decoder.decode(PapagoModel.self, from: data)
                    completion(papagoModel)
                } catch {
                    print("JSON 파싱 오류: \(error.localizedDescription)")
                    completion(nil)
                }
            } else if let error = error {
                print("API 요청 중 오류: \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        // API 요청 시작
        task.resume()
    }
}
