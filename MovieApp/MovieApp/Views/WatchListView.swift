//
//  FavoriteView.swift
//  MovieApp
//
//  Created by Aytan Gurbanova on 15.04.2024.
//

import SwiftUI

struct WatchListView: View {
  @ObservedObject var watchlist: WatchListModel
  @ObservedObject var movieViewModel: MovieDiscoverViewModel
  let columns = [GridItem(.flexible()), GridItem(.flexible())]
  @Binding var searchText: String

  var body: some View {
    ScrollView {
      Text("Watchlist")
        .font(.largeTitle)
        .kerning(2)
      if watchlist.watchlist.isEmpty && searchText.isEmpty {
        Text("List is empty")
          .padding(.top, 150)
      } else if !searchText.isEmpty {
        MovieList(movieViewModel: movieViewModel)
      } else {
        LazyVGrid(columns: columns) {
          ForEach(watchlist.watchlist) { item in
            NavigationLink {
              DescriptionView(movie: item)
            } label: {
              AsyncImage(url: item.posterURL) { image in
                image
                  .resizable()
                  .scaledToFill()
                  .frame(width: 100, height: 150)
              } placeholder: {
                ProgressView()
                  .frame(width: 80, height: 120)
              }
            }
          }
        }
      }
    }
    .onAppear {
      watchlist.updateFavorites()
    }
  }
}

#Preview {
  WatchListView(watchlist: WatchListModel(), movieViewModel: MovieDiscoverViewModel(), searchText: .constant(""))
}
