//
//  MovieList.swift
//  MovieApp
//
//  Created by Aytan Gurbanova on 12.04.2024.
//

import SwiftUI

struct HomeScreen: View {
  @ObservedObject var watchlist: WatchListModel
  @ObservedObject var movieViewModel: MovieDiscoverViewModel
  @Binding var searchText: String

  var body: some View {
    VStack {
      if searchText.isEmpty {
        FeaturedMovies(movieViewModel: movieViewModel, watchlist: watchlist)
      } else {
        MovieList(movieViewModel: movieViewModel)
      }
    }
    .environmentObject(watchlist)
  }
}

#Preview {
  HomeScreen(watchlist: WatchListModel(), movieViewModel: MovieDiscoverViewModel(), searchText: .constant(""))
}
