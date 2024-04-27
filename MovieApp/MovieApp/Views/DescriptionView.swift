//
//  DescriptionView.swift
//  MovieApp
//
//  Created by Aytan Gurbanova on 12.04.2024.
//

import SwiftUI

struct DescriptionView: View {
  @EnvironmentObject var watchlist: WatchListModel
  @Environment(\.horizontalSizeClass) private
  var horizontalSizeClass
  @StateObject var model = MovieDetailsViewModel()
  let movie: WatchableItem

  var body: some View {
    ScrollView {
      Spacer().frame(height: 250)
      VStack {
        PosterView(movie: movie)
        Spacer().frame(height: 80)
        VStack(alignment: .leading) {
          HStack {
            Text(movie.title ?? movie.name ?? "Unknown name")
              .font(.title)
            Button(action: {
              withAnimation(.easeInOut(duration: 1)) {
                if watchlist.isFavorite(movie: movie) {
                  watchlist.removeFromFavorites(movie: movie)
                } else {
                  watchlist.addToFavorites(movie: movie)
                }
              }
            }, label: {
              Image(systemName: watchlist.isFavorite(movie: movie) ? "heart.fill" : "heart")
                .foregroundStyle(watchlist.isFavorite(movie: movie) ? .red : .gray)
            })
            Spacer()
            Image(systemName: "hand.thumbsup")
            Text(String(movie.voteAvg.rounded()))
          }
          .bold()
          Text(movie.overview)
            .font(.headline)
            .padding()
          Text("Starring: ")
            .font(.title3)
            .bold()
          ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
              if movie.title == nil && movie.name != nil {
                ForEach(model.serieCastProfiles) { actor in
                  CastView(cast: actor)
                }
              } else {
                ForEach(model.movieCastProfiles) { actor in
                  CastView(cast: actor)
                }
              }
            }
          }
          Spacer()
        }
        .padding()
        .background(horizontalSizeClass == .compact ? .black.opacity(0.5) : .clear)
      }
    }
    .frame(maxHeight: .infinity)
    .background(.black)
    .padding(.vertical)
    .foregroundStyle(.white)
    .task {
      guard let movieID = movie.id else { return }
      await model.movieCredits(for: movieID)
      await model.serieCredits(for: movieID)
      await model.loadMovieCastImages()
      await model.loadSerieCastImages()
    }
  }
}

struct PosterView: View {
  @Environment(\.horizontalSizeClass) private
  var horizontalSizeClass
  let movie: WatchableItem
  var body: some View {
    AsyncImage(url: movie.posterURL) { image in
      image
        .resizable()
        .scaledToFill()
        .frame(minWidth: 400, maxHeight: 150)
        .padding(.bottom, 180)
    } placeholder: {
      ProgressView()
    }
  }
}

struct CastView: View {
  let cast: CastProfile
  var body: some View {
    VStack {
      AsyncImage(url: cast.photoURL) { image in
        image
          .resizable()
          .scaledToFit()
          .frame(width: 100, height: 160)
          .clipShape(RoundedRectangle(cornerRadius: 15))
      } placeholder: {
        ProgressView()
          .frame(width: 100, height: 160)
      }
      Text(cast.name)
        .frame(width: 100)
    }
  }
}

#Preview {
  DescriptionView(movie: .mockData)
    .environmentObject(WatchListModel())
}
