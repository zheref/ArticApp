//
//  ArtworkView.swift
//  ChicagoInstituteArt
//
//  Created by Sergio Daniel on 11/05/24.
//

import SwiftUI
import SwiftData

struct ArtworkView: View {
    @State var item: ArtworksItem
    @State var animationAmount = 0.25
    let interactor: ArtworkInteractorProtocol
    
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
                            .lineLimit(3)
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
        .toolbarBackground(.clear, for: .navigationBar)
        .ignoresSafeArea(.all)
        .toolbar { toolbar }
    }
    
    @ViewBuilder
    private var toolbar: some View {
        HStack {
            Spacer()
            Button(action: {
                interactor.toggleFavorite()
            }, label: {
                Image(systemName: item.isFavorite ? "heart.fill" : "heart")
                    .resizable()
                    .foregroundStyle(item.isFavorite ? Color.pink : Color.white)
                    .frame(width: 22, height: 20)
            })
            .overlay(
                Circle()
                    .offset(x: 2, y: -2)
                    .stroke(item.isFavorite ? .pink : .white)
                    .scaleEffect(animationAmount)
                    .opacity(2 - animationAmount)
                    .animation(
                        .easeInOut(duration: 1)
                            .repeatForever(autoreverses: false),
                        value: animationAmount
                    )
                    .frame(width: 30, height: 30)
                    .ignoresSafeArea(.all)
                    .layoutPriority(1000)
            )
            .frame(width: 30, height: 30)
            .onAppear {
                animationAmount = 2
            }
        }
    }
    
    private func imageUrl(for item: ArtworksItem) -> URL? {
        guard let iiifUrl = iiifUrl else { return nil }
        return item.imageUrl(usingIIIFUrl: iiifUrl)
    }
}

#Preview {
    let container = PreviewSampleData.previewSomeItems
    let firstItem: ArtworksItem! = container.firstInstance()
    let provider = ArtProvider(context: container.mainContext)
    let interactor = ArtworkInteractor(item: firstItem, provider: provider)
    return NavigationStack {
        ArtworkView(item: firstItem, interactor: interactor)
            .modelContainer(PreviewSampleData.previewSomeItems)
            .environment(\.iiifUrl, .iiifMock)
    }
}
