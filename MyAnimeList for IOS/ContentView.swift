//
//  ContentView.swift
//  MyAnimeList for IOS
//
//  Created by Haydar Bahr/ Abbas Kassem on 16/02/2023.

import SwiftUI

struct ContentView: View{
    @State private var bgColor = Color.white
    
    var body: some View {
        NavigationView{
            VStack {
                Button("Change Color") {
                    if bgColor == Color("Color1"){
                        bgColor = Color.white
                    } else { bgColor = Color("Color1")
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
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
            .background(bgColor)
            
            
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
