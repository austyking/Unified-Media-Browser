# Unified-Media-Browser

A Flutter app to browse content from multiple content providers (e.g. Netflix, Hulu) from a single
app. 

Created to learn the [Flutter](https://flutter.dev/) framework and best practices in structuring 
Flutter projects, separating frontend and backend logic, and using the 
[BLoC](https://flutter.dev/docs/development/data-and-backend/state-mgmt/options#bloc--rx) state 
management pattern.

## Demo

NOTE: Link to full demo in 60 fps: [Youtube Video](https://youtu.be/VEdR0Fzdzx8).


### Search Screen

Search "got"             |  Search "prison"
:-------------------------:|:-------------------------:
![](readme_media/p5__search_screen_1.gif)  |  ![](readme_media/p6__search_screen_2.gif)


### Transitions

Transition using Back Button            |  Transition using Swipe & Back Button 
:-------------------------:|:-------------------------:
![](readme_media/p7__transition_1.gif)  |  ![](readme_media/p8__transition_2.gif)


### Detail Screen

The Detail Screen shows detailed information about the Movie/Show selected. Note that only the 
Overview tab of this screen is implemented. 

<img src="readme_media/p2__detail_screen_tabs.gif" width="444" height="960">


### Auto Scroll to Fit

If a card is expanded and does not fit in the current view, then the detail screen will 
automatically scroll up.

Expanded Does Not Fit --> Auto Scroll   |  Expanded Fits --> No Auto Scroll 
:-------------------------:|:-------------------------:
![](readme_media/p1__auto_scroll_to_fit.gif)  |  ![](readme_media/p9__no_autoscroll.gif)


### Redirect

The Detail screen provides links to the media for each platform it's available on. If the 
streaming service app is installed on the user's phone, it will be opened 
([deep linking](https://en.wikipedia.org/wiki/Deep_linking)). 

App Installed on Device --> App   |  App not Installed on Device --> Web
:-------------------------:|:-------------------------:
![](readme_media/p3__itunes_redirect.gif)  |  ![](readme_media/p4__redirect_app_not_installed.gif)



## Motivation

Every production company is creating its own streaming platform and making their content exclusive 
to their platform. As a result, the average American subscribes to 3-4 streaming services
(source: [Forbes](https://www.forbes.com/sites/tonifitzgerald/2019/03/29/how-many-streaming-video-services-does-the-average-person-subscribe-to/?sh=27261d256301)).
When you know exactly what you want to watch, then a simple Google search will tell you which
services that show or movies is available on. 

However, if you don't know what to watch, then you need to browse through Netflix, and then Hulu, 
and then Disney+, etc., each with its own app and different way of selecting categories and so on. 
The motivation behind this app is to address this problem by providing a single app you can use to 
browse through all of the content available to you through the media services that you subscribe to
in a single app. 


## State of the App

The first milestone in bringing this idea to life is an app which can access and present media from 
all streaming services, which is where the app is (mostly) at.

The next step would be to build a recommendation system which recommends new media based on what 
you have watched before, and a view for browsing through all of these recommendations.
 

## Getting Started

Download project dependencies listed in `pubspec.yaml` using command:
```
flutter pub get
```


### API Keys
You need to update the template `lib/globals.dart` with your API keys.

To acquire your own API keys, follow the instructions on each site below:

* http://www.omdbapi.com/
* https://rapidapi.com/utelly/api/utelly

After you have your API keys from the above sites, follow these instructions for updating the
template file:

1. To prevent accidentally pushing your API keys to a shared repo, run:
```
git update-index --skip-worktree lib/globals.dart
```

This tells git not to track changes made to this file. Note that there are some
[caveats](https://stackoverflow.com/questions/13630849/git-difference-between-assume-unchanged-and-skip-worktree#) 
with this approach for if this template does need to be updated in the remote repo. 

2. Copy and paste your API keys into `lib/globals.dart`.

