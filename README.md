#  Artic App

Mobile app portraying content from Chicago Art Institute API:
https://api.artic.edu/docs

## Screenshots
<img src="https://github.com/zheref/ArticApp/assets/1177000/37f8ff59-5a1e-42fc-af29-02875e925ead" width="200">
<img src="https://github.com/zheref/ArticApp/assets/1177000/171cabb7-3097-4574-b2ec-8cc61a2aeee8" width="200">

## Summary
This iOS mobile codebase features:
- Heavy usage of SwiftUI, Combine, Concurrency and SwiftData.
- Nice way of encapsulating concept and creation of REST API endpoints.  
- Separation of view states onto a ViewModel for better testability and responsibility isolation.
- Standard architecture following a single responsiblity principle.
- Decoupling and dependency injection between artifacts to enhance testability.
- Isolation of domain agnostic logic allowing artifacts to be reused across codebases.
- Mocks for network and database data available only in development mode for the sake of previews **D**esign **D**riven **D**evelopment.
- JSON Serializable SwiftData-ready PersistentModels to avoid duplication of entities across the app.
- Added unit tests for services.

## Upcoming tasks
* Add some integration tests  
* Add snapshot tests  
* Enable main carousel on main screen for displaying favorites  
* Allowing to download images to FS to provide availability while offline  
* Enable users to see the piece of art in full screen  
