//
//  MovieDetailsViewModel.swift
//  MovieApp
//
//  Created by Aytan Gurbanova on 14.04.2024.
//

import Foundation

@MainActor
class MovieDetailsViewModel: ObservableObject {
  @Published var movieCredits: MovieData?
  @Published var serieCredits: MovieData?
  @Published var movieCastProfiles: [CastProfile] = []
  @Published var serieCastProfiles: [CastProfile] = []


  func movieCredits(for id: Int) async {
    guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/credits?api_key=\(apiKey)")
    else {
      print("Couldn't handle URL")
      return
    }
    do {
      let (data, response) = try await URLSession.shared.data(from: url)

      guard let httpsResponse = response as? HTTPURLResponse, (200..<300).contains(httpsResponse.statusCode)
      else {
        print("Invalid movieCredits response")
        return
      }
      print(httpsResponse.statusCode.description.localizedLowercase)

      let credits = try JSONDecoder().decode(MovieData.self, from: data)
      movieCredits = credits
    } catch {
      print(error.localizedDescription)
    }
  }

  func serieCredits(for id: Int) async {
    guard let url = URL(string: "https://api.themoviedb.org/3/tv/\(id)/credits?api_key=\(apiKey)")
    else {
      print("Couldn't handle URL")
      return
    }
    do {
      let (data, response) = try await URLSession.shared.data(from: url)

      guard let httpsResponse = response as? HTTPURLResponse, (200..<300).contains(httpsResponse.statusCode)
      else {
        print("Invalid serieCredits response")
        return
      }
      print(httpsResponse.statusCode.description.localizedLowercase)

      let credits = try JSONDecoder().decode(MovieData.self, from: data)
      serieCredits = credits
    } catch {
      print(error.localizedDescription)
    }
  }

  func loadMovieCastImages() async {
    guard let cast = movieCredits?.cast else { return }

    for person in cast {
      guard let url = URL(string: "https://api.themoviedb.org/3/person/\(person.id)?api_key=\(apiKey)") else {
        print("Couldn't handle cast images URL")
        return
      }
      do {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpsResponse = response as? HTTPURLResponse,
          httpsResponse.statusCode == 200
        else {
          print("Invalid loadMovies response")
        return
        }

        let profile = try JSONDecoder().decode(CastProfile.self, from: data)
        movieCastProfiles.append(profile)
      } catch {
        print(error.localizedDescription)
      }
    }
  }

  func loadSerieCastImages() async {
    guard let cast = serieCredits?.cast else { return }

    for person in cast {
      guard let url = URL(string: "https://api.themoviedb.org/3/person/\(person.id)?api_key=\(apiKey)") else {
        print("Couldn't handle cast images URL")
        return
      }
      do {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpsResponse = response as? HTTPURLResponse, httpsResponse.statusCode == 200
        else {
          print("Invalid loadSerieCastImage response")
          return
        }

        let profile = try JSONDecoder().decode(CastProfile.self, from: data)
        serieCastProfiles.append(profile)
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}


@MainActor
class MovieDiscoverViewModel: ObservableObject {
  @Published var trendingMovies: [WatchableItem] = []
  @Published var trendingSeries: [WatchableItem] = []
  @Published var searchResults: [WatchableItem] = []

  func loadTrendingMoviesList() {
    guard let url = URL(string: "https://api.themoviedb.org/3/trending/movie/day?api_key=\(apiKey)")
    else {
      print("Couldn't handle URL")
      return
    }

    Task {
      do {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpsResponse = response as? HTTPURLResponse, httpsResponse.statusCode == 200
        else {
          print("Invalid loadTrendingMovies response")
          return
        }

        let trendingResults = try JSONDecoder().decode(TrendingResults.self, from: data)
        trendingMovies = trendingResults.results
      } catch {
        print(error.localizedDescription)
      }
    }
  }

  func loadTrendingSeriesList() {
    guard let url = URL(string: "https://api.themoviedb.org/3/trending/tv/day?api_key=\(apiKey)")
    else {
      print("Couldn't handle URL")
      return
    }

    Task {
      do {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpsResponse = response as? HTTPURLResponse, httpsResponse.statusCode == 200
        else {
          print("Invalid loadTrendingSeries response")
          return
        }

        let trendingResults = try JSONDecoder().decode(TrendingResults.self, from: data)
        trendingSeries = trendingResults.results
      } catch {
        print(error.localizedDescription)
      }
    }
  }

  func search(text: String) {
    guard let url = URL(string: "https://api.themoviedb.org/3/search/multi?api_key=\(apiKey)&query=\(text)")
    else {
      print("Couldn't handle URL")
      return
    }
    Task {
      do {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpsResponse = response as? HTTPURLResponse, httpsResponse.statusCode == 200
        else {
          print("Invalid searchText response")
          return
        }

        let dataResults = try JSONDecoder().decode(TrendingResults.self, from: data)
        searchResults = dataResults.results
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}

class WatchListModel: ObservableObject {
  @Published var watchlist: [WatchableItem] = []

  let watchlistURL = FileManager.documentsDirectoryURL.appendingPathComponent("watchlist.json")

  func updateFavorites() {
    loadFavorites()
  }

  func addToFavorites(movie: WatchableItem) {
    guard !watchlist.contains(where: { $0.id == movie.id }) else { return }

    var updatedMovie = movie
    updatedMovie.isFavorite = true
    watchlist.append(updatedMovie)
    saveFavorite()
  }

  func removeFromFavorites(movie: WatchableItem) {
    if let index = watchlist.firstIndex(where: { $0.id == movie.id }) {
      watchlist.remove(at: index)
      saveFavorite()
    }
  }

  func saveFavorite() {
    do {
      let favoriteData = try JSONEncoder().encode(watchlist)
      try favoriteData.write(to: watchlistURL, options: .atomic)
    } catch {
      print("Error saving data to directory")
    }
  }

  func loadFavorites() {
    do {
      let jsonData = try Data(contentsOf: watchlistURL)
      watchlist = try JSONDecoder().decode([WatchableItem].self, from: jsonData)
    } catch {
      print("Error loading data from directory")
    }
  }

  func isFavorite(movie: WatchableItem) -> Bool {
    return watchlist.contains { $0.id == movie.id && $0.isFavorite == true }
  }
}

public extension FileManager {
  static var documentsDirectoryURL: URL {
    return `default`.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
}

private var apiKey: String {
  guard let filePath = Bundle.main.url(forResource: "TMDB-info", withExtension: "plist") else {
    fatalError("Couldn't find file 'TMDB-info.plist'.")
  }
  let plist = NSDictionary(contentsOf: filePath)
  guard let value = plist?["API_KEY"] as? String else {
    fatalError("Couldn't find key 'API_KEY' in 'TMDB-info.plist'.")
  }
  return value
}
