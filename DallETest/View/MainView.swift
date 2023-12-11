//
//  ContentView.swift
//  DallETest
//
//  Created by 김태은 on 2023/09/18.
//

import SwiftUI

struct MainView: View {
    @State private var isLoading = false
    
    @StateObject private var papagoViewModel = PapagoViewModel()
    @StateObject private var dallEViewModel = DallEViewModel()
    
    @State private var prompt: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State var imagesData: Array<DallEModel.Data> = []
    
    private var textFieldWidth: CGFloat = 280
    private var radius: CGFloat {return CGFloat(textFieldWidth / 2)}
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color(red: 0, green: 0, blue: 0).ignoresSafeArea()
                VStack() {
                    Image("logo")
                        .resizable()
                        .frame(width: 119, height: 119)
                        .foregroundColor(.accentColor)
                        .padding(EdgeInsets(top: 0, leading:0, bottom: 10, trailing: 0))
                    Text("DALL-E 2\nIMAGE GENERATE PROJECT")
                        .font(.custom("Pretendard", size:16).weight(.medium))
                        .foregroundColor(Color(red:1, green:1, blue: 1))
                        .multilineTextAlignment(.center)
                }
                .padding()
                
                VStack{
                    Spacer()
                    TextField("Enter Prompt", text: $prompt, onCommit: fetchPapago)
                        .frame(width: textFieldWidth, height: 52)
                        .font(.custom("Pretendard", size:22).weight(.regular))
                        .background(RoundedRectangle(cornerRadius: radius).fill( Color(red:1,green:1, blue:1)))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 0))
                        .multilineTextAlignment(.center)
                }
                
                if isLoading {
                    Color(red: 0, green: 0, blue: 0).ignoresSafeArea()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(2.0, anchor: .center)
                }
            }
            .navigationDestination(isPresented: .constant(!$imagesData.isEmpty), destination: {ReturnView(imageData: $imagesData)});
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("오류"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
        }
        .ignoresSafeArea()
    }
    
    func fetchPapago() {
        if(!prompt.isEmpty){
            isLoading = true
            papagoViewModel.postPapago(prompt: prompt) {papagoModel in
                if let papagoModel = papagoModel {
                    let translated = papagoModel.message.result.translatedText
                    print(translated)
                    fetchDallE(translated: translated)
                    prompt = ""
                } else {
                    showAlert = true
                    alertMessage = "번역 오류"
                    isLoading = false
                    prompt = ""
                }
            }
        }
    }
    
    func fetchDallE(translated: String) {
        dallEViewModel.postDallE(prompt: translated) {dallEModel in
            if let dallEModel = dallEModel {
                let data = dallEModel.data
                print(data)
                imagesData = data
                isLoading = false
                
            } else {
                showAlert = true
                alertMessage = "이미지 생성 오류"
                isLoading = false
            }
        }
    }
}

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
