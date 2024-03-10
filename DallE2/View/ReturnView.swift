//
//  ReturnView.swift
//  DallETest
//
//  Created by 김태은 on 2023/09/19.
//

import SwiftUI

struct ReturnView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var saveImageViewModel = SaveImageViewModel()
    
    @Binding var imageData: [DallEModel.Data]
    
    @State private var imageUrl: String = ""
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        VStack(alignment: .leading) {
            Button {
                imageData = []
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image("icon_left")
                    .frame(width: 15, height: 24)
            }
            .padding(EdgeInsets(top: 30, leading: 20, bottom: 20, trailing: 0))
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(imageData, id: \.self) { data in
                        AsyncImage(url: URL(string: data.url)) { image in
                            image.resizable()
                        } placeholder: {
                            Color(red: 0.85098, green: 0.85098, blue: 0.85098)
                        }
                        .cornerRadius(20)
                        .frame(width: 163.75, height: 163.75)
                        .padding([.horizontal, .vertical], 10.83)
                        .onTapGesture {
                            imageUrl = data.url
                            saveImageViewModel.checkAgree()
                        }
                        
                    }
                }
                .padding(EdgeInsets(top: 20, leading: 10.83, bottom: 0, trailing: 10.83))
            }
            .alert(isPresented: $saveImageViewModel.showAlert) {
                switch saveImageViewModel.activeAlert {
                case .isAgree: return Alert(
                    title: Text("확인"),
                    message: Text("이미지를 저장하시겠습니까?"),
                    primaryButton: .default(Text("저장"), action: {
                        saveImageViewModel.checkGranted(imageUrl: URL(string: imageUrl)!)
                    }),
                    secondaryButton: .cancel(Text("취소"))
                )
                    
                case .isNotGranted: return
                    Alert(title: Text("오류"), message: Text("앨범에 접근 권한이 없습니다. 설정에서 권한을 허용해주세요."), dismissButton: .default(Text("확인")))
                    
                case .isNotLoaded: return
                    Alert(title: Text("오류"), message: Text("이미지를 불러오는 중 오류가 발생하였습니다."), dismissButton: .default(Text("확인")))
                    
                case .isSaved: return
                    Alert(title: Text("알림"), message: Text("이미지를 저장하였습니다."), dismissButton: .default(Text("확인")))
                    
                case .isNotSaved: return
                    Alert(title: Text("오류"), message: Text("저장 중 오류가 발생하였습니다."), dismissButton: .default(Text("확인")))
                }
            }
        }
        .background(Color(red:0, green:0, blue: 0))
        .navigationBarBackButtonHidden(true)
    }
}

//struct ReturnView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReturnView()
//    }
//}
