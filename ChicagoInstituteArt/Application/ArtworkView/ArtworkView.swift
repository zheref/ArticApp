//
//  ArtworkView.swift
//  ChicagoInstituteArt
//
//  Created by Sergio Daniel on 11/05/24.
//

import SwiftUI

struct ArtworkView: View {
    let item: ArtworksItem
    let interactor: ArtworkInteractor
    
    @Environment(\.iiifUrl) var iiifUrl: URL?
    
    var body: some View {
        VStack {
            ZStack {
                AsyncImage(url: imageUrl(for: item)) {
                    $0.image?.resizable()
                }
                VStack {
                    Spacer()
                    HStack {
                        Text(item.title)
                            .font(.h1)
                            .foregroundStyle(Color.white)
                        Spacer()
                    }
                    if let artistTitle = item.artistTitle {
                        HStack {
                            Text("by \(artistTitle)")
                                .font(.h3)
                                .foregroundStyle(Color.white)
                            Spacer()
                        }
                    }
                }.padding()
            }
            ScrollView {
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.creditLine ?? "")
                            .font(.body1)
                    }
                    Spacer()
                }
                .padding()
            }
        }
        .ignoresSafeArea(.all)
    }
    
    private func imageUrl(for item: ArtworksItem) -> URL? {
        guard let iiifUrl = iiifUrl else { return nil }
        return item.imageUrl(usingIIIFUrl: iiifUrl)
    }
}

#Preview {
    let item: ArtworksItem = .mock
    let interactor = ArtworkInteractor(item: item)
    return ArtworkView(item: item, interactor: interactor)
}
