# Parkerly
 
:warning: Work in progress!

This is a prototype of a mobile parking app for iOS implemented as a part of a job application process. 
Please check `requirements` directory for the, well, requirements.

The main goal of this exercise was to design and implement the architecture for a traditional thin client app that connects to a REST backend. In this app, I use MVVM to implement the screens. Screen transitions are managed by the coordinators. Backend calls are performed through dedicated services. 

The project doesn't use any third-party libraries; this is intentional. However, it is still managed by Cocoapods and you have to open `.xcworkspace` file instead of `.xcodeproj` to run it.

This project was implemented in Xcode 9 using Swift 4 and targets iOS 11. Here, I didn't try to implement nice and polished custom layouts because this was not required, everything you'll see inside is standard UIKit controls.

Things that will most likely be de-scoped because of lack of time:
- method-level documentation
- unit / UI / snapshot tests   