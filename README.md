# Project 3 - Battwitter

Battwitter is a basic twitter app to read and compose tweets the [Twitter API](https://apps.twitter.com).

Time spent: 35 hours spent in total

## User Stories

The following **required** functionality is completed:

- [X] User can sign in using OAuth login flow.
- [X] User can view last 20 tweets from their home timeline.
- [X] The current signed in user will be persisted across restarts.
- [X] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.  In other words, design the custom cell with the proper Auto Layout settings.  You will also need to augment the model classes.
- [X] User can pull to refresh.
- [X] User can compose a new tweet by tapping on a compose button.
- [X] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
- [X] Hamburger menu
   - [X] Dragging anywhere in the view should reveal the menu.
   - [X] The menu should include links to your profile, the home timeline, and the mentions view.
- [X] Profile page
   - [X] Contains the user header view (implemented as a custom view)
   - [X] Contains a section with the users basic stats: # tweets, # following, # followers
- [X] Home Timeline
   - [X] Tapping on a user image should bring up that user's profile page

The following **optional** features are implemented:

- [X] When composing, you should have a countdown in the upper right for the tweet limit.
- [X] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [X] Retweeting and favoriting should increment the retweet and favorite count.
- [X] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [X] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
- [X] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.
- [ ] Pulling down the profile page should blur and resize the header image.
- [ ] Account switching
   - [ ] Long press on tab bar to bring up Account view with animation
   - [ ] Tap account to switch to
   - [ ] Include a plus button to Add an Account
   - [ ] Swipe to delete an account

The following **additional** features are implemented:

- [X] Inline media (photos)
- [X] View transition animations

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='https://github.com/mdeschamps/twitter/blob/master/twitter.gif?raw=true' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

## License

    Copyright 2016 Manuel Deschamps

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.