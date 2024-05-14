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
            RootContainer()
        }
        .modelContainer(.live)
    }
}

struct RootContainer: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        let artsState = ArtsViewModel()
        let artsInteractor = ArtsInteractor(state: artsState,
                                            provider: ArtProvider(context: modelContext),
                                            service: ArtService(client: .init()))
        
        ArtsView(state: artsState, interactor: artsInteractor)
            .onAppear {
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                NSLog("Document Path: %@", documentsPath)
            }
    }
    
}
