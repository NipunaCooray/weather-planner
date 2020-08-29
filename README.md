# WeatherSmartTodo

This is an early version of an app that I am planning to use to plan my daily activities (ex: biking to work, work from home, walks etc) according to weather.
On startup the app shows an alert if there is no internet.
The add plan button will stay disabled. But if there are already plans in the DB, these can be viewed by clicking on them on the table.
When internet is available, the app fetches weekly weather data from open weather api for user's location and when clicked on "Add plan" first user can see these.
Then by clicking on one of the weather records, user can add a plan that suits to that weather record. These will be saved to core data and the table on the first screen will update.
Editing plans is not implemented in this version.
A plan can be deleted by swiping left the record on the table.

## Implementation

The app has 3 view controller
1. WeatherPlanListViewController - shows the created plans
2. WeatherInfoViewController - shows weekly weather data 
3. AddPlanViewController - for user to create "weather-smart" plan

## How to build

Download and run the app on xcode. 

## Requirements

 - Xcode Version 11.3.1 
 - Swift 5.0

