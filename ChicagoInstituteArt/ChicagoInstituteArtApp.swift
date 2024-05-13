//
//  ChicagoInstituteArtApp.swift
//  ChicagoInstituteArt
//
//  Created by Sergio Daniel on 7/05/24.
//

import SwiftUI
import SwiftData

@main
struct ChicagoInstituteArtApp: App {
    var body: some Scene {
        WindowGroup {
            ArtsView(
                service: ArtService(client: .init())
            )
            .onAppear {
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                NSLog("Document Path: %@", documentsPath)
            }
        }
        .modelContainer(.live)
    }
}
