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
    @Query private var items: [Item]
    @State private var artItems = [ArtworksItem]()
    @State private var iiifUrl: URL?
    @State private var lastFetchedPage = 0
    
    let service: ArtServiceProtocol
    
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
            List {
                ForEach(artItems) { item in
                    NavigationLink {
                        HStack {
                            AsyncImage(url: url(for: item)) {
                                $0.image?.resizable()
                            }
                            Text("Item at \(item.title)")
                        }
                    } label: {
                        HStack {
                            if let imageString = item.thumbnail?.lqip,
                                let image = UIImage.fromBase64Uri(string: imageString) {
                                AsyncImage(url: url(for: item)) {
                                    $0.image?
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                }
                            }
                            Text(item.title)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
        .task {
            do {
                (artItems, iiifUrl) = try await service.fetchArtworks(page: lastFetchedPage + 1)
                lastFetchedPage += 1
            } catch {
                Print.error(error)
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    let service = ArtService(client: .forPreviews)
    return ArtsView(service: service)
            .modelContainer(for: Item.self, inMemory: true)
}
