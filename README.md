# ButtonWorld

ButtonWorld is a minimalist mobile game built around one action: **PRESS**.

## Current V1

- PRESS score: 1 press = 1 point
- Local persistence with SharedPreferences
- Firebase anonymous authentication
- Firestore player persistence
- Tap Streak with an 800 ms continuation window
- Best Tap Streak persistence
- Milestones
- Minimal profile
- Leaderboard shell for World / Country / Season
- Settings for sound and haptics
- Cosmetic market shell

## Run

```bash
fvm flutter pub get
fvm flutter run
```

Android/Firebase configuration is already present in the project.

## Important

The current client-side PRESS synchronization is intentionally simple for development. A production leaderboard should move score validation to trusted backend logic and add appropriate anti-cheat protections before competitive launch.
