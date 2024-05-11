//
//  UIKitExtensions.swift
//  ChicagoInstituteArt
//
//  Created by Sergio Daniel on 8/05/24.
//

import UIKit

extension UIImage {
    
    convenience init?(fromBase64String base64: String) {
        guard let data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters) else {
            return nil
        }
        self.init(data: data)
    }
    
    static func fromBase64Uri(string: String) -> UIImage? {
        guard let url = URL(string: string) else {
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        } catch {
            Print.error(error)
            return nil
        }
    }
    
}
