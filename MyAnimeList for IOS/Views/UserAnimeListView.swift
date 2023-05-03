//
//  UserAnimeList.swift
//  MyAnimeList for IOS
//
//  Created by Haydar Bahr on 27/04/2023.
//

import SwiftUI

struct UserAnimeListView: View {
    @ObservedObject var searchObjController = SearchObjController.shared
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        VStack{
            Text("User Anime List")
                .font(.title)
                .padding(.bottom, 4)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(searchObjController.animeList, id: \.node.id) { animeNode in
                        NavigationLink(destination: AnimeDetailView(animeId: animeNode.node.id)){
                            AnimeCardUser(anime: animeNode)
                        }
                    }
                }.padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
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
        UserAnimeListView()
    }
}

struct AnimeCardUser: View {
    var anime: AnimeListItem

    var body: some View {
        HStack{
            if let urlString = anime.node.main_picture.large,
                           let url = URL(string: urlString) {
                            AsyncImage(url: url) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 120, height: 180, alignment: .leading)
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
                    .frame(maxWidth: 260, alignment: .leading)
                
                Text("Status: \(anime.list_status.status.replacingOccurrences(of: "_", with: " ").capitalized)")
                    .font(.subheadline)
                    .lineLimit(2)
                    .padding(.top, 4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Watched episodes: \(anime.list_status.num_episodes_watched.description)")
                    .font(.subheadline)
                    .padding(.top, 4)
                    .frame(maxWidth: .infinity,alignment: .leading)
                
                if anime.list_status.score == 0 {
                    Text("Hasn't been rated yet")
                        .font(.subheadline)
                        .padding(.top, 4)
                        .frame(maxWidth: .infinity,alignment: .leading)
                }
                else{
                    Text("My rating: \(anime.list_status.score.description)")
                        .font(.subheadline)
                        .padding(.top, 4)
                        .frame(maxWidth: .infinity,alignment: .leading)
                }
            }
        }
    }
}
