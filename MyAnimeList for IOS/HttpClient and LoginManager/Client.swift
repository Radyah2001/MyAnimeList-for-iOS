//
//  Client.swift
//  MyAnimeList for IOS
//
//  Created by Haydar Bahr on 01/05/2023.
//

import Foundation

class SearchObjController: ObservableObject {
    static let shared = SearchObjController()
    private init(){
        details = AnimeDetails()
        userInfo = UserInfo()
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
    @Published var userInfo: UserInfo
    @Published var details: AnimeDetails
    @Published var topAnime: [NodeTop] = []
    @Published var airingAnime: [NodeTop] = []
    @Published var upcomingAnime: [NodeTop] = []
    @Published var animeList: [AnimeListItem] = []
    
    func resetDetails() {
        details = AnimeDetails()
    }
    
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
    
    func getUserInfo(token: String) async throws {
            
            let urlString = "https://api.myanimelist.net/v2/users/@me?fields=anime_statistics"
            guard let url = URL(string: urlString) else {
                throw APIError.invalidURL
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw APIError.invalidResponse
            }
            Task {@MainActor in
                userInfo = try JSONDecoder().decode(UserInfo.self, from: data)
                
                
            }
        }
    func getUserAnimeList(token: String) async throws {
            
            let urlString = "https://api.myanimelist.net/v2/users/@me/animelist?fields=list_status&limit=20"
            guard let url = URL(string: urlString) else {
                throw APIError.invalidURL
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw APIError.invalidResponse
            }
            Task {@MainActor in
                let res = try JSONDecoder().decode(AnimeListResponse.self, from: data)
                self.animeList.append(contentsOf: res.data)
                
                
            }
        }
    
    func updateAnimeListStatus(animeId: Int, status: String, token: String) {
        guard var urlComponents = URLComponents(string: "https://api.myanimelist.net/v2/anime/\(animeId)/my_list_status") else {
            print("Invalid URL")
            return
        }

        let statusQueryItem = URLQueryItem(name: "status", value: status)

        urlComponents.queryItems = [statusQueryItem]

        guard let url = urlComponents.url else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"

        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }

            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response: \(responseString)")
            }
        }

        task.resume()
    }


    
}
