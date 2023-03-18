# iOS Sample Application

iOS Sample Application implemented with Clean Architecture + MVVM and Coordinator Pattern. (Can be used as a Template project). 

## Functions
* Display previous and upcoming matches.
* Select a team for team details.
* Filter matches by team(s).
* Watch highlights of a previous match.

## Projects structure, technologies and methodologies
* Coordinator Pattern + Clean Architecture + MVVM as base structure
* UIKit and Combine (functional reactive programming).
* Snapkit for building UI programmatically
* Repository pattern for data layer abstraction
* Modular with Swift Package Manager
* CoreData as offline storage

## Challenging technical issues
* Missing API documentation and required fields for API responses: For example, there are no teamId and teamLogo fields for match entity => it makes us harder when implementing good UI for Match cell item in Home screen without team logo, beside that we have to pass teamName instead of teamId when open Team detail screen. I was thinking about calling both get teams and get matches APIs at the same time then combine their results but I decided I wouldn't do it because it is not a good practice (calling unnecessary API, comparing to get team by name instead of id). In the real development process I prefer to ask BE developer updating the API response.
* My missing knowledge of some Coding Requirements: To be honest, I did not have much experience using Swift Package Manager for locally modular. In my previous projects, I usually just used Swift Module for this purpose. But after some searching and reading tutorial articles I got the idea and successfully created two package Domain, Data and configured dependency for them (Main project should depend on Domain and Data, Data should depend on Domain).
* Assignment requires less usage of third-party dependencies so for some simple utilities action like load and cache image or showing loading progress I need to handle it myself and it takes time. But at the end I more understood about how NSCache class works.

## Future Improvements:
* Adding Units Test for all Use Cases, View Models and Utilities classes
* Adding appropriate descriptions to classess and methods
* Improve UI Home and Team Detail screens
* Resolve another todos
