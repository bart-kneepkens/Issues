<p align="center">
<img src="https://github.com/bart-kneepkens/NationStates-iOS/blob/main/docs/assets/app_icon_rounded.png" />
</p>

# Issues for NationStates

This repository contains the source for Issues, an iOS client for [NationStates](https://www.nationstates.net).

[<img src="https://github.com/bart-kneepkens/NationStates-iOS/blob/main/docs/assets/Download_on_the_App_Store_Badge_US-UK.svg">](https://apps.apple.com/us/app/issues-for-nationstates/id1543636795)

# ✨ Features 
- 📰 Get an overview of your pending issues
- 🕰 Know when the next issue arrives
- 📖 Read up on issues
- 📝 Respond appropriately by passing legislations 
- 📈 Keep track of your nation and its characteristics 
- 🌍 Read and vote on World Assembly resolutions
- 📦 Comes with a widget that displays issues on the home screen 

# ⚡️ Technology
Issues is mostly written using SwiftUI in conjunction with MVVM.
- Uses the official [NationStates API](https://www.nationstates.net/pages/api.html)
- Uses web scraping (SwiftSoup) in cases where the API doesn't offer certain features
- Core Data for persistence
- Most logic is built using Combine
