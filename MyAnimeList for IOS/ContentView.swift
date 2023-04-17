//
//  ContentView.swift
//  MyAnimeList for IOS
//
//  Created by Haydar Bahr/ Abbas Kassem on 16/02/2023.

import SwiftUI
import AuthenticationServices

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    @ObservedObject var searchObjController = SearchObjController.shared
    var body: some View {
        NavigationStack{
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    HStack {
                        Button(action: {
                            authManager.authorize()
                        }) {
                            Image("MAL")
                                .resizable()
                                .font(.title)
                                .scaledToFit()
                                .foregroundColor(.blue)
                                .frame(width:40, height: 40)
                                .padding()
                        }
                        Text("MyAnimeList")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.bottom, 5)
                            .padding(.leading, 20)
                        Spacer()
                        NavigationLink(destination: SearchView()) {
                            Image(systemName: "magnifyingglass")
                                .font(.largeTitle)
                                .foregroundColor(.blue)
                        }
                        Spacer()
                    }
                    VStack{
                        Text("Top Anime")
                            .font(.title)
                            .padding(.bottom, 4)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 20) {
                                ForEach(searchObjController.topAnime, id: \.node.id) { animeNode in
                                    NavigationLink(destination: AnimeDetailView(animeId: animeNode.node.id ?? 1)){
                                        AnimeCard(anime: animeNode)
                                    }
                                }
                            }.padding(.horizontal)
                        }
                        .onAppear {
                            if searchObjController.topAnime.isEmpty{
                                Task {
                                    do {
                                        try await searchObjController.getTrendingAnime()
                                    } catch {
                                        print("Error fetching trending anime: \(error.localizedDescription)")
                                    }
                                }
                            }
                        }
                    }.fixedSize(horizontal: false, vertical: true)
                    
                    VStack{
                        Text("Top Upcoming Anime")
                            .font(.title)
                            .padding(.bottom, 4)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 20) {
                                ForEach(searchObjController.upcomingAnime, id: \.node.id) { animeNode in
                                    NavigationLink(destination: AnimeDetailView(animeId: animeNode.node.id ?? 1)){
                                        AnimeCard(anime: animeNode)
                                    }
                                }
                            }.padding(.horizontal)
                        }
                        .onAppear {
                            if searchObjController.upcomingAnime.isEmpty {
                                Task {
                                    do {
                                        try await searchObjController.getUpcomingAnime()
                                    } catch {
                                        print("Error fetching trending anime: \(error.localizedDescription)")
                                    }
                                }
                            }
                        }
                    }.fixedSize(horizontal: false, vertical: true)
                    
                    VStack{
                        Text("Top Airing Anime")
                            .font(.title)
                            .padding(.bottom, 4)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 20) {
                                ForEach(searchObjController.airingAnime, id: \.node.id) { animeNode in
                                    NavigationLink(destination: AnimeDetailView(animeId: animeNode.node.id ?? 1)){
                                        AnimeCard(anime: animeNode)
                                    }
                                }
                            }.padding(.horizontal)
                        }
                        .onAppear {
                            if searchObjController.airingAnime.isEmpty{
                                Task {
                                    do {
                                        try await searchObjController.getAiringAnime()
                                    } catch {
                                        print("Error fetching trending anime: \(error.localizedDescription)")
                                    }
                                }
                            }
                        }
                    }.fixedSize(horizontal: false, vertical: true)
                }
                     
                
                            
                        
                 
                

            }
                     
            .navigationTitle("Home")
            
            
            Spacer()
        }
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        .background(Color("Color1"))
        .tint(Color.black)
    }
}

struct AnimeCard: View {
    var anime: NodeTop

    var body: some View {
        VStack(alignment: .leading) {
            if let urlString = anime.node.main_picture?.large,
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

            Text(anime.node.title ?? "Unknown")
                .font(.headline)
                .lineLimit(2)
                .padding(.top, 4)
                .frame(maxWidth: 120, alignment: .leading)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
