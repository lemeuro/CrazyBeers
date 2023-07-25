//
//  ContentView.swift
//  CrazyBeers
//
//  Created by Lem Euro on 21/07/2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var punkApi = PunkAPI()
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(searchResults) { beer in
                    VStack {
                        Text(beer.name)
                            .font(.title2).bold()
                            .multilineTextAlignment(.center)
                        Text(beer.tagline)
                        AsyncImage(url: URL(string: beer.image_url)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                            } else if phase.error != nil {
                                Text("There was an error loading the image.")
                            } else {
                                ProgressView()
                            }
                        }
                        .frame(width: 200, height: 300)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                }
                .searchable(text: $searchText)
            }
            .navigationTitle("BeerTest")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            await loadData()
        }
    }
    
    var searchResults: [Beer] {
        if searchText.isEmpty {
            return punkApi.beers
        } else {
            return punkApi.beers.filter { $0.name.contains(searchText) }
        }
    }

    
    func loadData() async {
        guard let url = URL(string: "https://api.punkapi.com/v2/beers") else {
            print("Server not responding")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            if let results = try? JSONDecoder().decode([Beer].self, from: data) {
                punkApi.beers = results
            }
        } catch {
            print("Invalid data")
        }
    }

}

//#Preview {
//    ContentView()
//}
