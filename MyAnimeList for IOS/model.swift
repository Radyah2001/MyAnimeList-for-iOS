//
//  model.swift
//
//
//  Created by Haydar Bahr on 23/02/2023.
//

import Foundation

struct AnimeList: Codable {
    var data: [Node]
}
struct AnimeListTrending: Codable {
    var data: [NodeTop]
}

struct NodeTop: Codable {
    var node: Anime
    var ranking: Ranking
    struct Anime: Codable, Identifiable {
        var id: Int?
        var title: String?
        var main_picture: MainPicture?
        
        struct MainPicture: Codable {
            var medium: String
            var large: String
        }
        
    }
    
}

struct Node: Codable {
    var node: Anime
    struct Anime: Codable, Identifiable {
        var id: Int?
        var title: String?
        var main_picture: MainPicture?
        
        struct MainPicture: Codable {
            var medium: String
            var large: String
        }
        
    }
    
}

struct Ranking: Codable {
    var rank: Int?
}

struct AnimeDetails: Codable {
    var id: Int?
    var title: String?
    var main_picture: MainPicture?
    
    struct MainPicture: Codable {
        var medium: String
        var large: String
    }
    var mean: Double?
    var rank: Int?
    var popularity: Int?
    var status: String?
    var genres: [Genres]?
    var synopsis: String?
    struct Genres: Codable{
        var id: Int?
        var name: String?
    }
    var rating: String?
    var num_episodes: Int?
    var statistics: Statistics?
    struct Statistics: Codable {
        var status: Status?
        struct Status: Codable {
            var watching: String?
            var completed: String?
            var on_hold: String?
            var dropped: String?
            var plan_to_watch: String?
        }
        var num_list_users: Int?
    }
}


class SearchObjController: ObservableObject {
    static let shared = SearchObjController()
    private init(){
        details = AnimeDetails()
    }
    
    enum APIError: Error {
        case invalidURL
        case invalidResponse
        case decodingError
        case serverError(statusCode: Int, message: String)
    }
    
    let token = "34093f65c502c0fd011391170d76458e"
    
    @Published var results: [Node] = []
    @Published var query: String = "" {
        didSet {
            // Reset the results list when the query changes
            results = []
        }
    }
    @Published var details: AnimeDetails
    @Published var topAnime: [NodeTop] = []
    @Published var airingAnime: [NodeTop] = []
    @Published var upcomingAnime: [NodeTop] = []
    
    
    
    func getAnimeDetails(id: Int) async throws {
        let urlString = "https://api.myanimelist.net/v2/anime/\(id)?fields=id,title,main_picture,synopsis,mean,rank,popularity,genres,num_episodes,rating,statistics,status"
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("\(token)", forHTTPHeaderField: "X-MAL-CLIENT-ID")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        Task {@MainActor in
            details = try JSONDecoder().decode(AnimeDetails.self, from: data)
        }
        
        
        
    }
    
    func getTrendingAnime() async throws {
        let urlString = "https://api.myanimelist.net/v2/anime/ranking?ranking_type=all&limit=10"
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("\(token)", forHTTPHeaderField: "X-MAL-CLIENT-ID")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        Task {@MainActor in
            let res = try JSONDecoder().decode(AnimeListTrending.self, from: data)
            self.topAnime.append(contentsOf: res.data)
        }
        
        
    }
    func getUpcomingAnime() async throws {
        let urlString = "https://api.myanimelist.net/v2/anime/ranking?ranking_type=upcoming&limit=10"
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("\(token)", forHTTPHeaderField: "X-MAL-CLIENT-ID")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        Task {@MainActor in
            let res = try JSONDecoder().decode(AnimeListTrending.self, from: data)
            self.upcomingAnime.append(contentsOf: res.data)
        }
        
        
    }
    func getAiringAnime() async throws {
        let urlString = "https://api.myanimelist.net/v2/anime/ranking?ranking_type=airing&limit=10"
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("\(token)", forHTTPHeaderField: "X-MAL-CLIENT-ID")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        Task {@MainActor in
            let res = try JSONDecoder().decode(AnimeListTrending.self, from: data)
            self.airingAnime.append(contentsOf: res.data)
        }
        
        
    }
    
    func search(){
        query = query.replacingOccurrences(of: " ", with: "_")
        guard let listUrl = URL(string: "https://api.myanimelist.net/v2/anime?q=\(query)&limit=20") else { fatalError("Missing URL") }
        var request = URLRequest(url: listUrl)
        request.httpMethod = "GET"
        request.setValue("\(token)", forHTTPHeaderField: "X-MAL-CLIENT-ID")
        
        let getListTask = URLSession.shared.dataTask(with: request){(data, response, error) in
            DispatchQueue.main.async {
                guard let data = data else {return}
                
                do {
                    let res = try JSONDecoder().decode(AnimeList.self, from: data)
                    self.results.append(contentsOf: res.data)
                }
                catch {
                    print(error)
                }
            }
        }
        getListTask.resume()
    }
    
}
