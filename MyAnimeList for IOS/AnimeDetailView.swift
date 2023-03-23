//
//  AnimeDetailView.swift
//  testing
//
//  Created by Haydar Bahr on 02/03/2023.
//

import SwiftUI

struct AnimeDetailView: View {
    var animeId: Int
    @StateObject var searchController = SearchObjController.shared
    @State private var isLoading = true

    var body: some View {
            ScrollView {
                VStack {
                    if isLoading {
                        ProgressView()
                            .onAppear{
                                isLoading = true
                            }
                    }
                        else {
                            if let animeDetails = searchController.details {
                                VStack(alignment: .leading, spacing: 20) {
                                    AsyncImage(url: URL(string: animeDetails.main_picture?.medium ?? "")) { phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 80, height: 120)
                                                .padding(.trailing, 8)
                                        }
                                    }
                                    Text("Average score: \(animeDetails.mean?.description ?? "Unknown")")
                                    Text("Rank: \(animeDetails.rank?.description ?? "Unknown")")
                                    Text("Popularity: \(animeDetails.popularity?.description ?? "Unknown")")
                                    Text("Status: \(animeDetails.status?.capitalized.replacingOccurrences(of: "_", with: " ") ?? "Unknown")")
                                    if let genres = animeDetails.genres {
                                        Text("Genres: \(genres.map { $0.name ?? "" }.joined(separator: ", "))")
                                    }
                                    Text("Number of episodes: \(animeDetails.num_episodes?.description ?? "Unknown")")
                                    Text("Synopsis:")
                                        .font(.headline)
                                    Text(animeDetails.synopsis ?? "No synopsis available.")
                                        .font(.body)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(nil)
                                    
                                    if let statistics = animeDetails.statistics {
                                        VStack(alignment: .leading, spacing: 10) {
                                            Text("Statistics:")
                                                .font(.headline)
                                            Text("Status:")
                                                .font(.subheadline)
                                            HStack(alignment: .top, spacing: 10) {
                                                Text("Watching:")
                                                Text(statistics.status?.watching ?? "Unknown")
                                            }
                                            HStack(alignment: .top, spacing: 10) {
                                                Text("Completed:")
                                                Text(statistics.status?.completed ?? "Unknown")
                                            }
                                            HStack(alignment: .top, spacing: 10) {
                                                Text("On Hold:")
                                                Text(statistics.status?.on_hold ?? "Unknown")
                                            }
                                            HStack(alignment: .top, spacing: 10) {
                                                Text("Dropped:")
                                                Text(statistics.status?.dropped ?? "Unknown")
                                            }
                                            HStack(alignment: .top, spacing: 10) {
                                                Text("Plan to Watch:")
                                                Text(statistics.status?.plan_to_watch ?? "Unknown")
                                            }
                                            Text("Number of List Users: \(statistics.num_list_users?.description ?? "Unknown")")
                                        }
                                        .font(.body)
                                    }
                                }
                                .padding()
                            } else {
                                ProgressView()
                            }
                            
                            
                        }
                    }
                }
        .task {
            isLoading = true
            do {
                try await searchController.getAnimeDetails(id: animeId)
            } catch {
                print("Error: \(error.localizedDescription)")
            }
            isLoading = false
        }.onDisappear{
            searchController.resetDetails()
        }
        .navigationTitle(searchController.details.title ?? "Unknown")
    }
}

/*
 struct AnimeDetailView_Previews: PreviewProvider {
 static var previews: some View {
 AnimeDetailView()
 }
 }
 */
