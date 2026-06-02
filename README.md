# fit_ness_territory

A Flutter fitness app that gamifies running by letting users compete 
for territory ownership on real-world routes around Auckland, NZ.

## Overview

fit_ness_territory turns running into a competition. Users run predefined
routes and can claim ownership of a "territory" by setting the fastest
time on that route. Territory records are stored in Firebase and synced
in real time across all users

## Features

- **Territory OwnerShip:** run a route and claim it by beating the current fastest time
- **Live GPS Tracking:** tracks your path against the selected territory route vis Google Maps
- **Run Stats:** distance, time, steps and calories tracked per run
- **Friends System:** add other users and sees their activity
- **Scoreboard:** leaderboard showing territory owners and best times
- **Profile:** personal stats including total runs, best run, distance traveled and calories
- **Privacy Toggle:** option to make your profile private

## Territories (Auckland)

- Waitakere Rangers Track
- Cornwall Park Track
- Auckland Domain Track
- Shakespear Regional Track

## Tech Stack

- **Flutter (Dart):** cross-platform mobile app(IOS & Android)
- **Firebase Auth:** user authentication
- **Cloud Firestore:** real-time database for users, runs and territories
- **Google Maps Flutter:** map rendering and route display
- **Geolocator:** GPS position tracking

## Getting Started

1. Clone the repo
2. Run 'flutter pub get'
3. add your Google Maps API key to `lib/map/map_api_key.dart` and `android/app/src/main/AndroidManifest.xml`
4. Set up a Firebase project and add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
5. Run `flutter run`

## Firebase Collections

| Collection | Fields |
|---|---|
| `users` | username, email, bestRun, totalRuns, totalRunTime, totalSteps, distanceTravelled, totalCalories, friends, profilePicUrl, isPrivate |
| `runs` | userId, username, time, date, territoryName |
| `territories` | territoryName, currentOwner, fastestTimeSeconds, runId, updatedAt, imageUrl |

