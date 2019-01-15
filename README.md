# MQR (MAP QUEST REMAKE) 
Ever wondered how to build Apple Maps, the UI &amp; searching functionality, from scratch? 
My App, MQR(Map Quest Remake) or simply an "OK" version of Apple Maps, accesses the users current location and helps to search for locations based on search query. With the destination searched, user will get a mileage or the total distance between the two points. Will Implement More!

# All Done PROGRAMMATICALLY (NO STORYBOARD)
Sorry =(

## Demo
![mqrlocationaccess](https://user-images.githubusercontent.com/36717095/51064484-e53d7580-15cd-11e9-883c-4c4a68ad8952.gif)
![mqrtransition](https://user-images.githubusercontent.com/36717095/51064652-bbd11980-15ce-11e9-908a-cb59519057a8.gif)
![mqrsearch](https://user-images.githubusercontent.com/36717095/51065184-8843be80-15d1-11e9-831c-37587df76d94.gif) 

## Requirements
<pre>
IDE: Xcode (NEEDED TO OPEN)
Language&Version: Swift 4.2  
Developing software for mainly, macOS, iOS, watchOS, and tvOS.
</pre>

## Git Clone Terminal Over HTTPS

<pre>
$ git clone https://github.com/tetraprism95/MQR.git 
</pre> 

## Features

- CoreLocation
- MapKit
- UITableView
- UIActivityIndicatorView
- UIPanGestureRecognizer
- Created multiple functions to calculate the transition of the sheet.
- Extensions for convenience. Especially UIView to anchor the constraints efficiently.
- AND MORE...

## Bugs

- When running the application the first time, during the sheet transition from mid to top or bot to top, tableView will not be scrolled down first time, need to pan through it again. After the repetition of panning, it will work smoothly.  

- Not able to satisfy couple constraints. Will Fix Soon. 

## Code Structure?

- Yes, I know I need enum. Will update soon.
- Also to add DispatchQueue.main.async when needed. 
- Create extra extension for classes that use it's functionality a lot. 
- I will try to make it more readable for the user.

## Future Updates? Will Add..
- app logo
- Overlay Views
- Polylines
- length in time between two points
- suggestions
- etc.....


