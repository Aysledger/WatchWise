//
//  MovieList.swift
//  MovieApp
//
//  Created by Aytan Gurbanova on 14.04.2024.
//

import SwiftUI

struct MovieList: View {
  @ObservedObject var movieViewModel: MovieDiscoverViewModel
  @EnvironmentObject var watchlist: WatchListModel
  @Environment(\.colorScheme) private
  var colorScheme
  var body: some View {
    ScrollView {
      LazyVStack(alignment: .leading) {
        ForEach(movieViewModel.searchResults, id: \.id) { item in
          NavigationLink(destination: DescriptionView(movie: item)) {
            HStack {
              AsyncImage(url: item.backdropURL) { image in
                image
                  .resizable()
                  .scaledToFill()
                  .frame(width: 80, height: 120)
              } placeholder: {
                ProgressView()
                  .frame(width: 80, height: 120)
              }
              .clipped()
              .clipShape(RoundedRectangle(cornerRadius: 10))
              VStack(alignment: .leading) {
                Text(item.title ?? item.name ?? "Unknown name")
                  .multilineTextAlignment(.leading)
                  .font(.headline)
                HStack {
                  Image(systemName: "hand.thumbsup")
                  Text(String(item.voteAvg.rounded()))
                }
              }
              .foregroundStyle(colorScheme == .dark ? .white : .black)
            }
          }
        }
        .padding()
      }
    }
  }
}


#Preview {
  MovieList(movieViewModel: MovieDiscoverViewModel())
}
