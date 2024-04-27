//
//  MovieModel.swift
//  MovieApp
//
//  Created by Aytan Gurbanova on 13.04.2024.
//

import Foundation

struct TrendingResults: Codable {
  let page: Int
  let results: [WatchableItem]
  let totalPages: Int
  let totalResults: Int

  enum CodingKeys: String, CodingKey {
    case page, results
    case totalPages = "total_pages"
    case totalResults = "total_results"
  }
}

struct WatchableItem: Codable, Identifiable {
  var id: Int?
  let adult: Bool
  let title: String?
  let name: String?
  let backdropPath: String?
  let poster: String?
  let voteAvg: Float
  let overview: String
  var isFavorite: Bool? = false
  var backdropURL: URL? {
    let baseURL = URL(string: "https://image.tmdb.org/t/p/w500")
    return baseURL?.appending(path: backdropPath ?? "")
  }

  var posterURL: URL? {
    let baseURL = URL(string: "https://image.tmdb.org/t/p/w500")
    return baseURL?.appending(path: poster ?? "")
  }

  enum CodingKeys: String, CodingKey {
    case id, adult, title, overview, name, isFavorite
    case poster = "poster_path"
    case backdropPath = "backdrop_path"
    case voteAvg = "vote_average"
  }

  static var mockData: WatchableItem {
    return WatchableItem(
    adult: false,
    title: "Dune",
    name: "Dune",
    backdropPath: "/lzWHmYdfeFiMIY4JaMmtR7GEli3.jpg",
    poster: "/d5NXSklXo0qyIYkgV94XAgMIckC.jpg",
    voteAvg: 7.8,
    overview: "Paul Atreides, a brilliant and gifted young man born into a great destiny beyond his",
    isFavorite: false)
  }
}

struct MovieData: Codable {
  let id: Int
  let cast: [Cast]

  struct Cast: Codable, Identifiable {
    let name: String
    let id: Int
    let character: String
  }
}

struct CastProfile: Codable, Identifiable {
  let id: Int
  let name: String
  let profilePath: String?

  var photoURL: URL? {
    let baseURL = URL(string: "https://image.tmdb.org/t/p/w200")
    return baseURL?.appending(path: profilePath ?? "")
  }

  enum CodingKeys: String, CodingKey {
    case id, name
    case profilePath = "profile_path"
  }
}
