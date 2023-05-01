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

struct UserInfo: Codable {
    let id: Int?
    let name: String?
    let location: String?
    let joined_at: String?
    let anime_statistics: AnimeStatistics?
    init() {
            self.id = nil
            self.name = nil
            self.location = nil
            self.joined_at = nil
            self.anime_statistics = nil
        }
    
        struct AnimeStatistics: Codable {
            let num_items_watching: Int?
            let num_items_completed: Int?
            let num_items_on_hold: Int?
            let num_items_dropped: Int?
            let num_items_plan_to_watch: Int?
            let num_items: Int?
            let num_days_watched: Double?
            let num_days_watching: Double?
            let num_days_completed: Double?
            let num_days_on_hold: Int?
            let num_days_dropped: Int?
            let num_days: Double?
            let num_episodes: Int?
            let num_times_rewatched: Int?
            let mean_score: Double?
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

struct AnimeListResponse: Codable {
    let data: [AnimeListItem]
}

struct AnimeListItem: Codable {
    let node: Node
    let list_status: ListStatus
    struct ListStatus: Codable {
        let status: String
        let score: Int
        let num_episodes_watched: Int
        let is_rewatching: Bool
        let updated_at: String
        let start_date: String?
        let finish_date: String?
    }
    struct Node: Codable {
        let id: Int
        let title: String
        let main_picture: MainPicture
        struct MainPicture: Codable {
            let medium: String
            let large: String
        }
        
    }
}





struct Paging: Codable {
    let next: String
}
