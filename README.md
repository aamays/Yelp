## Yelp

This is a Yelp search app using the [Yelp API](http://developer.rottentomatoes.com/docs/read/JSON).

Time spent: 15 hours


### Features

#### Required

- [x] Search results page
   - [x] Table rows should be dynamic height according to the content height
   - [x] Custom cells should have the proper Auto Layout constraints
   - [x] Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).
- [x] Filter page. Unfortunately, not all the filters are supported in the Yelp API.
   - [x] The filters you should actually have are: category, sort (best match, distance, highest rated), radius (meters), deals (on/off).
   - [x] The filters table should be organized into sections as in the mock.
   - [x] Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.
   - [x] Display some of the available Yelp categories (choose any 3-4 that you want).

#### Optional

- [x] Search results page
   - [x] Infinite scroll for restaurant results
   - [x] Implement map view of restaurant results
- [x] Filter page
   - [x] Radius filter should expand as in the real Yelp app
   - [x] Categories should show a subset of the full list with a "See All" row to expand. Category list is here: http://www.yelp.com/developers/documentation/category_list (Links to an external site.)
- [x] Implement the restaurant detail page.
   - [x] Implement map view of restaurant
- [ ] Implement a custom switch

#### Additional

- [x] Implement CoreLocation and provide search results based on user's current location
- [x] Ability to call the business from tapping the call section from business details view


### Walkthrough

#### Portrait

![Video Walkthrough](YelpDemoPortrait.gif)

#### Landscape

![Video Walkthrough](YelpDemoLandscape.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

#### Development/Testing environment

* Operating System: Yosemite v10.10.5
* Xcode v7.0
* iOS v9.0
* Devices
 * iPhone 6 Simulator

#### Further improvements to do:

* Update map view to tap on pin annotation to segue to BusinessDetailsViewController
* Test for more corner cases
* Custom Switch Control
* Custom Pin Annotations for Map view
