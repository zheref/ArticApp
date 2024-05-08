//
//  Print.swift
//  ChicagoInstituteArt
//
//  Created by Sergio Daniel on 8/05/24.
//

import Foundation

var Print = (
    debug: { (s: String) in print(s) },
    error: { (e: Error) in
        let ns = e as NSError
        print("\(ns.domain) \(ns.code)")
        print(ns.localizedDescription)
        for (key, value) in ns.userInfo {
            print("\(key): \(value)")
        }
    }
)
