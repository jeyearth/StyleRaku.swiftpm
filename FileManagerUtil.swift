//
//  FileManagerUtil.swift
//  StyleRaku
//  
//  Created by Jey Hirano on 2025/01/24
//  
//

import UIKit

struct FileManagerUtil {
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    // ユニークな画像ファイル名を生成
    static func getUniqueImageFileName() -> String {
        return UUID().uuidString + ".png"
    }
    
    /// 画像を保存
//    static func saveImage(_ image: UIImage, fileName: String) -> String? {
//        let fileURL = documentsDirectory.appendingPathComponent(fileName)
//        if let data = image.jpegData(compressionQuality: 0.8) {
//            do {
//                try data.write(to: fileURL)
//                return fileURL.lastPathComponent // 保存したファイル名を返す
//            } catch {
//                print("Error saving image: \(error)")
//                return nil
//            }
//        }
//        return nil
//    }
    
    // 透過png対応メソッド
    static func saveImage(_ image: UIImage, fileName: String) -> String? {
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        // PNGデータを取得
        if let data = image.pngData() {
            do {
                try data.write(to: fileURL)
                return fileURL.lastPathComponent // 保存したファイル名を返す
            } catch {
                print("Error saving image: \(error)")
                return nil
            }
        } else {
            print("Failed to generate PNG data.")
            return nil
        }
    }
    
    /// 画像を読み込み
    static func loadImage(fileName: String) -> UIImage? {
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    /// 画像を削除
    static func deleteImage(fileName: String) {
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch {
                print("Error deleting image: \(error)")
            }
        }
    }
}
