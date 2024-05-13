//
//  ContentView.swift
//  ChicagoInstituteArt
//
//  Created by Sergio Daniel on 7/05/24.
//

import SwiftUI
import SwiftData

struct ArtsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var artItems: [ArtworksItem]
    @State private var iiifUrl: URL?
    @State private var lastFetchedPage = 0
    
    let service: ArtServiceProtocol
    
    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    init(service: ArtServiceProtocol) {
        self.service = service
    }
    
    private func url(for item: ArtworksItem) -> URL? {
        guard let iiifUrl = iiifUrl else { return nil }
        let endpoint = ImagesEndpoint.image(iiifUrl: iiifUrl, imageId: item.imageId)
        return try? endpoint.createURL()
    }

    var body: some View {
        NavigationSplitView {
            ScrollView {
                LazyVGrid(columns: adaptiveColumn, spacing: 10, content: {
                    ForEach(artItems) { item in
                        NavigationLink {
                            ArtworkView(item: item, iiifUrl: iiifUrl)
                        } label: {
                            itemCell(forItem: item)
                        }
                    }
                })
                .padding(10)
            }
            .ignoresSafeArea(.keyboard)
            .background(Color.background)
            .navigationTitle("Artic Gallery")
        } detail: {
            Text("Select an item")
        }
        .task {
            do {
                let (_, iiifUrl) = try await service.fetchArtworks(page: lastFetchedPage + 1)
                self.iiifUrl = iiifUrl
                lastFetchedPage += 1
            } catch {
                Print.error(error)
            }
        }
    }
    
    @ViewBuilder
    private func itemCell(forItem item: ArtworksItem) -> some View {
        HStack {
            Spacer()
            VStack() {
                Spacer()
                AsyncImage(url: url(for: item)) {
                    $0.image?
                        .resizable()
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                Spacer(minLength: 10)
                Text(item.title)
                    .font(.h4)
                    .foregroundStyle(Color.black)
                Spacer()
            }
            Spacer()
        }
        .padding(5)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    let service = ArtService(client: .forPreviews)
    return ArtsView(service: service)
            .modelContainer(PreviewSampleData.previewSomeItems)
}
