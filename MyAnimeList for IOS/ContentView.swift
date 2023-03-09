//
//  ContentView.swift
//  MyAnimeList for IOS
//
//  Created by Haydar Bahr/ Abbas Kassem on 16/02/2023.

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            VStack {
                HStack {
                    Button(action: {
                        // do nothing, since this is already the current view
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
                ScrollView{
                    Image("MAL")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
