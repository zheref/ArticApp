#  Artic App

Mobile app portraying content from Chicago Art Institute API:
https://api.artic.edu/docs

## Summary
This iOS mobile codebase features:
- Heavy usage of SwiftUI and SwiftData.
- Separation of view states onto a ViewModel for better testability and responsibility isolation.
- Standard architecture following a single responsiblity principle.
- Decoupling and dependency injection between artifacts to enhance testability.
- Isolation of domain agnostic logic allowing artifacts to be reused across codebases.
- Mocks for network and database data available only in development mode for the sake of previews **D**esign **D**riven **D**evelopment.

## Upcoming tasks
[ ] Add proper unit tests for main artifacts
[ ] Add some integration tests
[ ] Add snapshot tests
[ ] Enable main carousel on main screen for displaying favorites
[ ] Allowing to download images to FS to provide availability while offline
[ ] Enable users to see the piece of art in full screen.
