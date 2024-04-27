//
//  OnboardingView.swift
//  MovieApp
//
//  Created by Aytan Gurbanova on 12.04.2024.
//

import SwiftUI

struct OnboardingView: View {
  @StateObject private var watchlist = WatchListModel()
  @StateObject var movieViewModel = MovieDiscoverViewModel()
  @Environment(\.horizontalSizeClass) private
  var horizontalSizeClass

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack {
          Image("Onboarding")
            .resizable()
            .scaledToFit()
            .frame(width: horizontalSizeClass == .compact ? 300 : 400)
          Text("Time to chill")
            .font(.largeTitle)
            .bold()
            .multilineTextAlignment(.center)
          Text("Not sure what to watch today?🍿 Discover trending movies/TV series")
            .font(.title3)
            .padding()
            .multilineTextAlignment(.center)
          Text("Don't want to lose it? \nAdd to your watchlist📝")
            .font(.title3)
            .padding()
            .multilineTextAlignment(.center)


          NavigationLink(destination: TabViews(watchlist: watchlist, movieViewModel: movieViewModel)) {
            Text("Start Now")
              .font(.title)
              .foregroundStyle(.white)
              .bold()
              .frame(width: 200, height: 50)
              .background(Color(red: 0.698, green: 0.196, blue: 0.200))
              .clipShape(.buttonBorder)
              .padding()
          }
        }
      }
    }
    .environmentObject(watchlist)
  }
}

#Preview {
  OnboardingView()
}
