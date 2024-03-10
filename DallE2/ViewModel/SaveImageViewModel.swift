import Foundation
import SwiftUI
import Photos

class SaveImageViewModel: ObservableObject {
    enum ActiveAlert {
        case isAgree, isNotGranted, isNotLoaded, isSaved, isNotSaved
    }
    
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var activeAlert: ActiveAlert = .isAgree
    
    func checkAgree() {
        showAlert = true
        activeAlert = .isAgree
    }
    
    func checkGranted(imageUrl: URL) {
        print("권한 체크 시작")
        
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                DispatchQueue.main.async {
                    self.loadImage(imageUrl: imageUrl)
                    print("권한 test 성공")
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert = true
                    self.activeAlert = .isNotGranted
                    print("권한 없음")
                }
            }
        }
    }
    
    func loadImage(imageUrl: URL) {
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            if let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let uiImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.saveToAlbum(uiImage: uiImage)
                        print("이미지 로드 및 저장 성공")
                    }
                } else {
                    self.showAlert = true
                    self.activeAlert = .isNotLoaded
                    print("이미지 로드 실패")
                }
            } else if let error = error {
                self.showAlert = true
                self.activeAlert = .isNotLoaded
                print("이미지 로드 오류: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func saveToAlbum(uiImage: UIImage) {
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: uiImage)
        } completionHandler: { success, error in
            if success {
                self.showAlert = true
                self.activeAlert = .isSaved
                print("이미지 저장 완료")
            } else if let error = error {
                self.showAlert = true
                self.activeAlert = .isNotSaved
                print("이미지 저장 오류: \(error.localizedDescription)")
            }
        }
    }
}
