# Rick and Morty iOS App
An iOS app that allows fans of Rick and Morty to search for various characters and view information about them. They also have the option to view information about the various episodes which are sorted by season for ease of use. Internet connection is required!

**Link to project:** LINK HERE

ADD A VIDEO DEMO HERE


## How It's Made:

**Tech used:** Swift, UIKit, REST API

The app relies on various Network calls made to a Rick and Morty REST like API, so as stated previously an internet connection is a must. However, in the event you experience bad netowrk conditions, the app features some basic error handling to notify you. 


## Optimizations
*Caching Images*

Some minor optimizations were made via the use of a cache. Each of the character images are cached to allow seamless scrolling, preventing the wrong image from being loaded into a different cell. Using a cache also minimzes the need to constantly be redownloading the image from the web.

*Expandable TableViewCell*

A great quality of life optimzation was made by refactoring how the EpisodeTableView functions entirely. The original approach to expand the EpisodeTableViewCell was to utilize a StackView that contained two Views. As the user selected a TableViewCell, the cell would expand, revealing a hidden View or the second View in the StackView. However, this approach resulted in a very buggy experience when scolling the TableView. This was most noticeble when scrolling up rapidly as the TableView would stutter before returing to normal. I tried various things like reloading the TableViewCells in different ways, reloading the View, etc, but ultimately decided to redo the whole implementation. This new approach now just sets the height of the cell when it is selected and reloads the row. This resulted in a much smoother experience as a TableView should give, and no more stutters! It was also much less complicated as a StackView was not required, allowing the code to be slimmed down a bit. Hooray!


## Lessons Learned:
Overall, I learned a ton building this app and when I started it, I could not put it down. It was my first well organized app that tried its best to follow MVC design patterns. I learned to make various Views more reusable, as well as, using helpers to take care of pesky task that were perfomed alot like selecting colors, images, etc. I learned about and implemented caching which greatly helped the app's overall user experience. Though it may seem easy to do now, I throughly enjoyed adding the expanding TableViewCell. It presented me with the greatest challenge in the project, so ironing out the bugs was very fulfilling.

