//
//  TrendingMovie.swift
//  MovieApp
//
//  Created by Aytan Gurbanova on 13.04.2024.
//

import SwiftUI
import Foundation

struct FeaturedMovies: View {
  @ObservedObject var movieViewModel: MovieDiscoverViewModel
  @ObservedObject var watchlist: WatchListModel
  var body: some View {
    let trendingMovies = movieViewModel.trendingMovies
    let trendingSeries = movieViewModel.trendingSeries

    ScrollView {
      if trendingMovies.isEmpty {
        Text("No Results")
      } else {
        HStack {
          Text("Trending Movies")
            .fontWeight(.heavy)
            .font(.title)
          Spacer()
        }
        TrendingScrollViewMovie(watchlist: watchlist, movieViewModel: movieViewModel)
          .padding(.bottom)
      }

      if trendingSeries.isEmpty {
        Text("No Results")
      } else {
        HStack {
          Text("Trending Series")
            .fontWeight(.heavy)
            .font(.title)

          Spacer()
        }
        TrendingScrollViewSerie(watchlist: watchlist, movieViewModel: movieViewModel)
      }
    }
    .padding()
    .onAppear {
      movieViewModel.loadTrendingMoviesList()
      movieViewModel.loadTrendingSeriesList()
    }
  }
}


struct TrendingMovie: View {
  @ObservedObject var watchlist: WatchListModel
  var trendingItem: WatchableItem
  var body: some View {
    ZStack(alignment: .bottom) {
      AsyncImage(url: trendingItem.backdropURL) { image in
        image
          .resizable()
          .scaledToFit()
          .frame(width: 300, height: 200)
      } placeholder: {
        ZStack {
          Rectangle().fill(Color.gray)
            .frame(width: 300, height: 200)
          ProgressView()
            .frame(width: 300, height: 200)
        }
      }
      VStack(alignment: .leading) {
        HStack(alignment: .firstTextBaseline) {
          Text(trendingItem.title ?? trendingItem.name ?? "Unknown name")
          Spacer()
          Button(action: {
            withAnimation(.easeInOut(duration: 1)) {
              if watchlist.isFavorite(movie: trendingItem) {
                watchlist.removeFromFavorites(movie: trendingItem)
              } else {
                watchlist.addToFavorites(movie: trendingItem)
              }
            }
          }, label: {
            Image(systemName: watchlist.isFavorite(movie: trendingItem) ? "heart.fill" : "heart")
              .foregroundStyle(watchlist.isFavorite(movie: trendingItem) ? .red : .white)
          })
        }

        HStack {
          Image(systemName: "hand.thumbsup")
          Text(String(trendingItem.voteAvg.rounded()))
        }
      }
      .frame(height: 30)
      .fontWeight(.heavy)
      .foregroundStyle(.white)
      .padding()
      .background(Color(red: 0.078, green: 0.078, blue: 0.078).opacity(0.5))
    }
    .clipShape(RoundedRectangle(cornerRadius: 15))
  }
}

struct TrendingScrollViewMovie: View {
  @ObservedObject var watchlist: WatchListModel
  @ObservedObject var movieViewModel: MovieDiscoverViewModel
  var body: some View {
    let trending = movieViewModel.trendingMovies
    ScrollView(.horizontal) {
      HStack(spacing: 30) {
        ForEach(trending, id: \.id) { trendingItem in
          NavigationLink {
            DescriptionView(movie: trendingItem)
          } label: {
            TrendingMovie(watchlist: watchlist, trendingItem: trendingItem)
          }
        }
      }
    }
  }
}

struct TrendingScrollViewSerie: View {
  @ObservedObject var watchlist: WatchListModel
  @ObservedObject var movieViewModel: MovieDiscoverViewModel
  var body: some View {
    let trending = movieViewModel.trendingSeries
    ScrollView(.horizontal) {
      HStack(spacing: 30) {
        ForEach(trending, id: \.id) { trendingItem in
          NavigationLink {
            DescriptionView(movie: trendingItem)
          } label: {
            TrendingMovie(watchlist: watchlist, trendingItem: trendingItem)
          }
        }
      }
    }
  }
}

#Preview {
  TrendingMovie(watchlist: WatchListModel(), trendingItem: .mockData)
}

#Preview {
  FeaturedMovies(movieViewModel: MovieDiscoverViewModel(), watchlist: WatchListModel())
}
