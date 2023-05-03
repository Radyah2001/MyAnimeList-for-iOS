import SwiftUI

struct ProfileView: View {
    @StateObject var searchController = SearchObjController.shared
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    UserInfoSection(userInfo: searchController.userInfo)
                    AnimeStatisticsSection(animeStats: searchController.userInfo.anime_statistics)
                    NavigationLink(destination: UserAnimeListView()){
                        Text("Anime User List")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                }
                .padding()
                .frame(maxWidth:.infinity,maxHeight: .infinity)
            }
            .background(Color(.systemGroupedBackground))
            .edgesIgnoringSafeArea(.bottom)
            .navigationTitle("Profile")
            .toolbar{ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Your logout action here
                    authManager.logout()
                }) {
                    Text("Logout")
                }}
            }
        }
    }
}

struct UserInfoSection: View {
    let userInfo: UserInfo?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("User Information")
                .font(.largeTitle)
                .fontWeight(.bold)

            if let userInfo = userInfo {
                let strategy = Date.ParseStrategy(format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)T\(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits)\(timeZone: .iso8601(.short))", timeZone: .current)
                let date = try? Date(userInfo.joined_at?.description ?? "0", strategy: strategy)
                VStack(alignment: .leading, spacing: 8) {
                    Text("ID: \(userInfo.id ?? 0)")
                    Text("Name: \(userInfo.name ?? "N/A")")
                    Text("Joined at: \(date?.formatted() ?? "N/A")")
                }
                .font(.title2)
                .fontWeight(.medium)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
}

struct AnimeStatisticsSection: View {
    let animeStats: UserInfo.AnimeStatistics?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Anime Statistics")
                .font(.largeTitle)
                .fontWeight(.bold)

            if let animeStats = animeStats {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Watching: \(animeStats.num_items_watching ?? 0)")
                    Text("Completed: \(animeStats.num_items_completed ?? 0)")
                    Text("On Hold: \(animeStats.num_items_on_hold ?? 0)")
                    Text("Dropped: \(animeStats.num_items_dropped ?? 0)")
                    Text("Plan to Watch: \(animeStats.num_items_plan_to_watch ?? 0)")
                    Text("Total Items: \(animeStats.num_items ?? 0)")
                    Text("Episodes Watched: \(animeStats.num_episodes ?? 0)")
                    Text("Times Rewatched: \(animeStats.num_times_rewatched ?? 0)")
                    Text("Mean Score: \(animeStats.mean_score ?? 0.0)")
                }
                .font(.title2)
                .fontWeight(.medium)
            } else {
                Text("No anime statistics available.")
                    .font(.title2)
                    .fontWeight(.medium)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

