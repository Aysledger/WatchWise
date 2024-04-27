# WatchWise movie app
App which shows trending movies/TV series and helps to save them to watchlist


## Table of contents
- [Description](#description)
- [Getting started](#getting-started)
- [Rubric completion](#rubric-completion)
- [Design](#design)
- [API](#api)

<img width="348" alt="Screenshot 2024-04-23 at 13 45 17" src="https://github.com/Aysledger/ColorPicker/assets/61873412/5438d137-3a42-42a8-92a3-c545fce60016">
<img width="375" alt="Screenshot 2024-04-23 at 13 45 45" src="https://github.com/Aysledger/ColorPicker/assets/61873412/f4c5050d-5ccd-49e7-8745-fa70d33ca414">


### Description
WatchWise is a simple and straightforward movie app for discovering trending movies/TV series and allows user to search for anything which is not trending as well. It shows overview of each movie with actors starring in it and app also allows user to save it in watchlist in order not to lose it
### Getting started
1. Make sure you have the Xcode version 15.0 or above installed on your computer
2. Dowload the WatchWise project files from the repository
3. Open the project files in Xcode
4. Run it with desired simulator
5. Ready to surf around

### Rubric completion
- The project is implemented using the MVVM architecture pattern
- App doesn not use any third party frameworks or packages
- The app has static launch screen and onboarding screen to start with
- App has **List view** in **MovieList.swift**, **Grid view** on **WatchlistView.swift** and **ScrollView** almost everywhere around the app.
- App has 2 tabs: *Discover* tab has 2 ScrollViews with trending items and *Watchlist* tab has gridview with liked movie posters.
- Each item in the lists has at least title or image and clicking on it navigates user to *Description* view where extended information about the same item is listed(overview, rating, big poster, actors starring in it and button to add it to Watchlist)
- Network calls are stored in URLSessions folder
- App is using files for data storage, specifically JSON files. It saves the user's watchlist locally in a JSON file named "watchlist.json" located in the app's documents directory. The WatchListModel class manages the encoding and decoding of data to and from this JSON file.
- Additionally, app uses a plist file named "TMDB-info.plist" to store the API key. The *apiKey* property fetches the API key stored in this plist file. Plist file is added to .gitignore. File itself will be added to google doc for reference
- The app handles all typical errors and communicates to the user whenever data is missing or empty
- async/await, and MainActor used appropriately in **MovieDetailsViewModel** to keep slow-running tasks off the main thread and to update the UI on the main thread
- **MovieDetailsViewModel** includes ObservableObject and Published properties and app has several view that is subscribed to Published value.
- Views work for landscape and portrait orientations for the full range of iPhone sizes, including iPhone SE 2. In *Description* view for landscape mode text under the poster is moved up a bit to take less space. But in order for the text to be shown clearly over the poster, black background with opacity was added behind the white text
- The project has a test plan including both UI and unit test with the coverage of 62%
- App inclides, custom app icon, onboarding screen, display name *WatchWise*, animation when pressing heart icon both on Trendingitem view and Description view, all the texts are styled properly

### Design
Initial Wireframe was completely different. You can check it [here](https://balsamiq.cloud/swtbtoq/pq7wvmg/r2278)  
Final designs are taken from [Dribble](https://dribbble.com/shots/23061907-Movie-App-Dark) but modified later

### API
[TMDB api](https://developer.themoviedb.org/docs/getting-started) was used for building database   
Api calls used are from [this](https://developer.themoviedb.org/reference/intro/getting-started) list 
