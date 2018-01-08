# Parkerly

This is a prototype of a mobile parking app for iOS implemented as a part of a job application process. 
Please check `requirements` directory for, well, requirements.

The main goal of this exercise was to design and implement the architecture for a traditional thin client app that connects to a REST backend powered by Firebase. In this app, I mostly adhere to MVVM architecture for implementing the screens. Screen transitions are managed by the coordinators. Backend calls are performed through dedicated services with some network layer scaffolding. I put some reasonable effort to make networking as generic as possible. 

This project was implemented in Xcode 9 using Swift 4 and targets iOS 11. Here, I didn't try to implement nice and polished custom layouts because this was not required, everything you'll see inside is standard UIKit controls. The views are laid out programmatically using layout guides and anchors.

The code is split between two production targets. `ParkerlyCore` contains non-UI code (models, networking, generic helpers and so on), `Parkerly` contains the UI.

Inside `Parkerly` target you'll find three different flows, namely `Authentication`, `Parking` and `Settings`. Each flow is powered by an own coordinator. There's also an `AppCoordinator` to rule them all.

Most screens are implemented as tables based on generic `TableWithOptionalButton` code.  

The project doesn't use any third-party libraries; this is intentional. However, it is still managed by Cocoapods and you have to open `.xcworkspace` file instead of `.xcodeproj` to run it.

Things that were de-scoped because of lack of time:
- data editing screens; instead of allowing to type in the details, I use default values or random data
- extracting navigation and building from coordinators 
- code documentation
- unit / UI / snapshot tests
- better strings handling (e.g. with `Localizable.strings`)
- it's not possible to go to vehicles from the user profile, but there's a separate menu item
- many other improvements, like empty and loading states, more robust networking and so on

There are some todos in code that indicate places to be improved, they were left intentionally.   

This was a nice assignment, I wish you to have as much fun reviewing this code as I had writing it.

## Screenshots

![Login](https://raw.githubusercontent.com/dzzh/parkerly/master/screenshots/2-login.png)
![Registration](https://raw.githubusercontent.com/dzzh/parkerly/master/screenshots/3-registration.png)
![Start parking](https://raw.githubusercontent.com/dzzh/parkerly/master/screenshots/4-start_parking.png)
![Parking action](https://raw.githubusercontent.com/dzzh/parkerly/master/screenshots/5-parking_action.png)
![History](https://raw.githubusercontent.com/dzzh/parkerly/master/screenshots/6-history.png)
![Menu](https://raw.githubusercontent.com/dzzh/parkerly/master/screenshots/7-menu.png)
![Profile](https://raw.githubusercontent.com/dzzh/parkerly/master/screenshots/8-profile.png)
![Vehicles](https://raw.githubusercontent.com/dzzh/parkerly/master/screenshots/9-vehicles.png)
