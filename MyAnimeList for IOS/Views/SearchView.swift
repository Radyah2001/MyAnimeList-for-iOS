//
//  SearchView.swift
//  MyAnimeList for IOS
//
//  Created by Haydar Bahr on 09/03/2023.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var searchController = HTTPClientController.shared
    
    
    var body: some View {
        VStack {
            NavigationStack{
                VStack{
                    TextField("Search anime", text: $searchController.query, onCommit: {
                        searchController.search()
                    }).padding(.leading, 18)
                        .accessibilityIdentifier("searchTextField")
                    List(searchController.results, id: \.node.id) { node in
                        NavigationLink(destination: AnimeDetailView(animeId: node.node.id ?? 1)){
                            HStack {
                                AsyncImage(url: URL(string: node.node.main_picture?.medium ?? "")) {phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 80, height: 120)
                                            .padding(.trailing, 8)
                                    }
                                    
                                }
                                VStack(alignment: .leading) {
                                    Text(node.node.title ?? "Unknown Title")
                                        .font(.headline)
                                }
                            }
                        }
                    }
                    .navigationTitle("Anime Search")
                
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
