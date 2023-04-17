//
//  MyAnimeList_for_IOSApp.swift
//  MyAnimeList for IOS
//
//  Created by Haydar Bahr on 16/02/2023.
//

import SwiftUI

@main
struct MyAnimeList_for_IOSApp: App {
    @StateObject private var authManager = AuthManager()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(authManager).onOpenURL{
                url in authManager.handleCallbackURL(url: url)
            }
        }
    }
}
