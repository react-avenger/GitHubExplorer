# GitHubExplorer
A Github Explorer project created in flutter using Git RESTFUL API and StateProvider.

## Feature
- Get repositories from public api for flutter user.
- Display them on list view and save repository.
- You can see the saved repository and can unsaved them.

## ScreenShots
![Image 1](https://user-images.githubusercontent.com/66963804/90644370-47eafe80-e252-11ea-9fbf-bf57de05484c.png)

![Image 2](https://user-images.githubusercontent.com/66963804/90644382-4b7e8580-e252-11ea-9c66-1e205fdc2db7.png)

![Image 3](https://user-images.githubusercontent.com/66963804/90644386-4c171c00-e252-11ea-9a71-e6ebad9591bc.png)

![Image 4](https://user-images.githubusercontent.com/66963804/90644388-4cafb280-e252-11ea-8296-897685cc7351.png)

## Getting Started
The Github Explorer contains the minimal implementation required to create project. The repository code is preloaded with some basic components like basic app architecture, app theme, constants and required dependencies to create a new project. By using Github Explorer code as standard initializer. This will also help in reducing setup & development time by allowing you to use same code pattern and avoid re-writing from scratch.

## How to Use
Step 1:

Download or clone this repo:

Step 2:

Go to project root and execute the following command in console to get the required dependencies:

flutter pub get


## Folder Structure
Here is the core folder structure which flutter provides.

github_explorer/
|- android
|- build
|- fonts
|- ios
|- lib
|- test

## Here is the folder structure we have been using in this project

lib/
|- listener/
|- model/
|- observer/
|- preference/
|- server/
|- views/
|- main.dart
|- utilities.dart


1- listener - Contains the listener for listen all the event handled by project.
2- model - Contains the model file for the data which we are getting from the api and store.
3- observer - Contains observers added to the list for getting live changes on list. (We can add other details for this observer like add, edit, delete, update)
4- preference — Contains all the data to the local storage methods.
5- server — Contains the server request to get data from the github api.
6- views — Contains the views (Screens) for your applications.
7- utilities.dart — This file contains utilities/common functions of your application.
8- main.dart - This is the starting point of the application. All the application level configurations are defined in this file i.e, theme, routes, title, orientation etc.

## Conclusion
Again to note, this is example can appear for what it is - but it is an example only. I have used default setState for managing state management in this application as this is the very small funcionality demo so we can use this in minimal implementation and working condition application. I can use the other state management systems like Redux and MobX but for this demo i used the default state management system `setState` which provide by the flutter.
