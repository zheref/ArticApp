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
    @State private var lastFetchedPage = 0
    
    let service: ArtServiceProtocol
    
    init(service: ArtServiceProtocol) {
        self.service = service
    }

    var body: some View {
        NavigationSplitView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
//                    } label: {
//                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
            List {
                ForEach(artItems) { item in
                    Text(item.title)
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
                artItems = try await service.fetchArtworks(page: lastFetchedPage + 1)
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
