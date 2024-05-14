//
//  ContentView.swift
//  ChicagoInstituteArt
//
//  Created by Sergio Daniel on 7/05/24.
//

import SwiftUI
import SwiftData

struct ArtsView: View {
    let state: ArtsViewModel
    let interactor: ArtsInteractorProtocol
    
    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    init(state: ArtsViewModel, interactor: ArtsInteractorProtocol) {
        self.state = state
        self.interactor = interactor
    }
    
    private func imageUrl(for item: ArtworksItem) -> URL? {
        guard let iiifUrl = state.iiifUrl else { return nil }
        return item.imageUrl(usingIIIFUrl: iiifUrl)
    }

    var body: some View {
        NavigationSplitView {
            ScrollView {
                LazyVGrid(columns: adaptiveColumn, spacing: 10, content: {
                    ForEach(state.artItems) { item in
                        NavigationLink {
                            let itemInteractor = ArtworkInteractor(item: item)
                            ArtworkView(item: item, interactor: itemInteractor)
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
            .onAppear {
                 interactor.fetchArtworks()
            }
        } detail: {
            Text("Select an item")
        }
        .environment(\.iiifUrl, state.iiifUrl)
    }
    
    @ViewBuilder
    private func itemCell(forItem item: ArtworksItem) -> some View {
        HStack {
            Spacer()
            VStack() {
                Spacer()
                AsyncImage(url: imageUrl(for: item)) {
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
    let state = ArtsViewModel()
    let service = ArtService(client: .forPreviews)
    let provider = ArtProvider(context: PreviewSampleData.previewSomeItems.mainContext)
    let interactor = ArtsInteractor(state: state,
                                    provider: provider,
                                    service: service)
    
    return ArtsView(state: state, interactor: interactor)
            .modelContainer(PreviewSampleData.previewSomeItems)
}

private struct IIIFUrlKey: EnvironmentKey {
    static let defaultValue: URL? = nil
}

extension EnvironmentValues {
  var iiifUrl: URL? {
    get { self[IIIFUrlKey.self] }
    set { self[IIIFUrlKey.self] = newValue }
  }
}
