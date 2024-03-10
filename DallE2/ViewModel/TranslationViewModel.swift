//
//  PapagoViewModel.swift
//  DallETest
//
//  Created by 김태은 on 12/5/23.
//

import Foundation

class TranslationViewModel: ObservableObject {
    var openAIApiKey: String {
        guard let plistPath = Bundle.main.path(forResource: "SecureKeys", ofType: "plist"),
              let plistDict = NSDictionary(contentsOfFile: plistPath) else {
            fatalError("SecureKeys.plist를 찾을 수 없어요.")
        }
        
        guard let value = plistDict["OpenAI_API_KEY"] as? String else {
            fatalError("OpenAI_API_KEY를 찾을 수 없어요.")
        }
        
        return value
    }
    
    func postTranslation(prompt: String, completion: @escaping (TranslationModel?) -> Void) {
        let url = "https://api.openai.com/v1/chat/completions"
        
        // Header 세팅
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(openAIApiKey)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "user", "content": "translate \"\(prompt)\" to English, without explanation"]
            ],
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        // API 요청
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                     // if let jsonString = String(data: data, encoding: .utf8) {
                     //     print("Received JSON data: \(jsonString)")
                     // }
                    
                    // DallEModel JSON 디코드
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(TranslationModel.self, from: data)
                    completion(model)
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
