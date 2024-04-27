//
//  TabViews.swift
//  MovieApp
//
//  Created by Aytan Gurbanova on 17.04.2024.
//

import SwiftUI

struct TabViews: View {
  @ObservedObject var watchlist: WatchListModel
  @ObservedObject var movieViewModel: MovieDiscoverViewModel
  @State private var searchText: String = ""

  var body: some View {
    NavigationStack {
      TabView {
        HomeScreen(watchlist: watchlist, movieViewModel: movieViewModel, searchText: $searchText)
          .tabItem {
            Label("Discover", systemImage: "magnifyingglass")
          }

        WatchListView(watchlist: watchlist, movieViewModel: movieViewModel, searchText: $searchText)
          .tabItem {
            Label("Watchlist", systemImage: "eye")
          }
      }
      .searchable(text: $searchText)
      .onChange(of: searchText) { _, newValue in
        if newValue.count > 2 {
          movieViewModel.search(text: newValue)
        }
      }
    }
    .navigationBarBackButtonHidden()
  }
}

#Preview {
  TabViews(watchlist: WatchListModel(), movieViewModel: MovieDiscoverViewModel())
}
