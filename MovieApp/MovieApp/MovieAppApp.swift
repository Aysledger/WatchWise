//
//  MovieAppApp.swift
//  MovieApp
//
//  Created by Aytan Gurbanova on 12.04.2024.
//

import SwiftUI

@main
struct MovieAppApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(WatchListModel())
    }
  }
}
