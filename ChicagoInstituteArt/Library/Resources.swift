//
//  Resources.swift
//  ChicagoInstituteArt
//
//  Created by Sergio Daniel on 8/05/24.
//

import Foundation

extension Data {
    
    static func fromJSONFile(withName name: String) -> Data? {
        guard let path = Bundle.main.path(forResource: name, ofType: "json") else { return nil }
        return try? Data(contentsOf: .init(filePath: path), options: .mappedIfSafe)
    }
    
}
