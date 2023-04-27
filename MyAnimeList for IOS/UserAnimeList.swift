//
//  UserAnimeList.swift
//  MyAnimeList for IOS
//
//  Created by Haydar Bahr on 27/04/2023.
//

import SwiftUI

struct UserAnimeList: View {
    @ObservedObject var searchObjController = SearchObjController.shared
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        VStack{
            Text("User Anime List")
                .font(.title)
                .padding(.bottom, 4)
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 20) {
                    ForEach(searchObjController.animeList, id: \.node.id) { animeNode in
                        NavigationLink(destination: AnimeDetailView(animeId: animeNode.node.id)){
                            AnimeCardUser(anime: animeNode)
                        }
                    }
                }.padding(.horizontal)
            }
            .onAppear {
                if searchObjController.animeList.isEmpty{
                    Task {
                        do {
                            try await searchObjController.getUserAnimeList(token: authManager.getAccessToken() ?? "0")
                        } catch {
                            print("Error fetching trending anime: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }.fixedSize(horizontal: true, vertical: false)
    }
}

struct UserAnimeList_Previews: PreviewProvider {
    static var previews: some View {
        UserAnimeList()
    }
}

struct AnimeCardUser: View {
    var anime: AnimeListItem

    var body: some View {
        HStack() {
            if let urlString = anime.node.main_picture.large,
                           let url = URL(string: urlString) {
                            AsyncImage(url: url) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 120, height: 180)
                                        .cornerRadius(10)
                                } else {
                                    Image("MAL")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 120, height: 180)
                                        .cornerRadius(10)
                                }
                            }
                        }
            VStack{
                
                Text(anime.node.title)
                    .font(.headline)
                    .lineLimit(2)
                    .padding(.top, 4)
                    .frame(maxWidth: 120, alignment: .leading)
                
                Text("Status: \(anime.list_status.status.replacingOccurrences(of: "_", with: " "))")
                    .font(.subheadline)
                    .lineLimit(2)
                    .padding(.top, 4)
                    .frame(maxWidth: 120, alignment: .leading)
            }
        }
    }
}
