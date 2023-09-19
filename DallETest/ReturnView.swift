//
//  ReturnView.swift
//  DallETest
//
//  Created by 김태은 on 2023/09/19.
//

import SwiftUI

struct ReturnView: View {
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var body: some View {
        VStack(alignment: .leading){
            Image("icon_left")
                .frame(width: 15, height: 24)
                .padding(EdgeInsets(top: 30, leading: 20, bottom: 20, trailing: 0))
            ScrollView{
                LazyVGrid(columns: columns){
                    ForEach((0...7), id: \.self) { _ in
                              Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1))
                                .cornerRadius(20)
                                .frame(width: 150, height: 150)
                                .padding()
                            }
                }.padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
            }
        }
        .background(Color(red:0, green:0, blue: 0))
    }
    
}

struct ReturnView_Previews: PreviewProvider {
    static var previews: some View {
        ReturnView()
    }
}
