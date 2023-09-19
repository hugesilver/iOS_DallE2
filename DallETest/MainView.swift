//
//  ContentView.swift
//  DallETest
//
//  Created by 김태은 on 2023/09/18.
//

import SwiftUI

struct MainView: View {
    @State var prompt: String = ""
    var width: CGFloat = 280
    var radius: CGFloat {return CGFloat(width / 2)}
    
    var body: some View {
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
                TextField("Enter Prompt", text: $prompt)
                    .frame(width: width, height: 52)
                    .font(.custom("Pretendard", size:22).weight(.regular))
                    .background(RoundedRectangle(cornerRadius: radius).fill( Color(red:1,green:1, blue:1)))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 0))
                    .multilineTextAlignment(.center)
            }
        }.ignoresSafeArea()
    }
}



struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
