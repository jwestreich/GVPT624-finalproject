# GVPT624 Final Project - Global Terrorism Database GeoGuessr

This is an outline of how my customer version of GeoGuessr using locations of terrorist attacks from the Global Terrorist Database works.

## 1. Picking Locations
The process begins by reading in a copy of the Global Terrorism Database, which is a dataset with a record for every terrorist attack recorded since 1970. A version of the file with all rows, but only few columns, was used to minimize run time.

A random number, uniformly distributed between 0 and 1, is assigned to every attack. Rows are sorted ascendingly by this random number, and the 20 observations with the lowest random number are kept. These are the randomly selected locations for the game. Upcoming steps will keep only 5, but 20 are initially chosen to ensure enough locations can be used.

## 2. Checking if Google Maps Street View has coverage
Google Maps has a suite of APIs, one of which helps with this step. I used one of their APIs to determine if each of the locations has Google Maps Street View coverage. Many of the originally randomly selected locations happen in remote locations or areas that are not on roads that do not have Street View coverage. The first five locations out of the original 20 selected locations are kept. If less than 5 locations have Street View coverage, the script will return an error and the process will have to be rerun.

## 3. Collecting Street View Images
Another API in the Google Maps suite allows a user to download an image from Google Maps Street View. The mandatory parameters of this API call are the size, location, heading (horizontal angle), and pitch (vertical angle). The size was kept a standard size (2048x2048 pixels), and the pitch was kept at 0 (meaning parallel to the ground). The location was provided from the coordinates from the Global Terrorism Database that had been randomly selected and then found to have Google Maps Street View coverage.

In order to collect a 360 degree view of a location, multiple images were collected for each location, with the heading varied each time. 5 images were collected for each location, varying the heading by 72 degrees each time. Between these 5 images, a full 360 degree view around that location is available.

## 4. Giving Players Access to the Images
The images are first downloaded locally to the host’s computer. A quick quality check of the images is helpful, to ensure all locations really do have Street View images and that the locations have some defining features that correctly guessing the location is theoretically possible.
The host then uploads these images to a publicly accessible Google Drive folder. Once the pictures are in the folder, players can begin looking at them and guessing the locations.

## 5. Players Guessing
The interface players use to submit guesses is an R Shiny dashboard. This functions as a form that collects information, and then lets players send the information to a place that I can access.

The first part that requires some player interaction is a team name. This is useful so we can assign guesses to a particular person.

The next part is a set of leaflet maps. Players can zoom in and move around on the map as they please. When a player taps on the map, a pin will drop in the exact location that they tapped. Tapping the map will also trigger a textbox below the map to populate with the exact coordinates of that location. This was some nice positive feedback to the players that they were actually making some kind of guess.

All the way at the bottom is a big Submit button. Using the googlesheets4 package and some authentication, hitting that submit button sends all of the information to a Google Sheet. This is a designated place that players can submit information to, and I can collect when the time comes.

## 6. Measuring and Scoring Guesses
Once a set amount of time is up, all the players have submitted their guesses on the Shiny dashboard, which means they are in the Google Sheet. A Google Drive API imports the data from the Google Sheet into a dataframe in R.

The R environment now has the actual locations and the guessed locations. These dataframes are merged by the location number, so both sets of coordinates (actual and guessed) are in the same row. The distHaversine function in the geosphere library can calculate the distance between guesses and actual locations, and multiply by a constant to convert that distance to miles or feet.

In the real GeoGuessr game, the score for each guess is inversely related to the distance from the location, but the relationship is not linear. Instead, it is exponential, where the closer you are to the real location, the more the scores can increase rapidly. The equation looks like this:

$$score = 5000 \cdot e^{-10 \cdot distance / max distance}$$

Where distance is the distance from the guess to the actual location, and max_distance is a fixed value that is the width of the entire playable area. The maximum score is 5000, which is why that number is at the front of the equation. This scoring method rewards making affirmative, confident guesses, and punishes guessing randomly when players are unsure.

## 7. Visualizing Gameplay
For each location, R produces a leaflet plot showing the real location and all the guessed locations, connected by lines. This creates a kind of spider web-looking map of all the guesses and the real location. Clicking on each of the guesses reveals the team name, how far they were, and the score they got.
