# Flutter Cookbook

The API owner released "random search" for free now ?? so I wanted to do something based around that. Still features viewing recipes (the main feature) but the search has instead been replaced with a lottery. It also has a more explicit DB hit in the form of "what's a global recipe saved", which ALSO has a bit of a try-catch because the component I was using (firedart) would occasionally wig out with a gRPC error in the form of being unable to reach the firestore DB.

Works all fine, albiet a bit slow. **I wasn't sure how to only notify certain components** of the page at a time; and most of Flutter's "finer points" ellude me a bit. It works, wish I could async call the cards, wish I figured out how to make my loading bar properly without infinite re-compiling the page every progress tick, etc.
I don't think more time would've changed that though, we had plenty of in-and-out of class time to make the project but I think the framework just doesn't click with me. The docs were crumby too-- I bounced between a bunch of widgets and stack overflow answers to make those json call cards. There was a (in hindsight, funny) error where I was making unsecure http calls and it just Wouldn't let me access the API at all. http -> https on the links solved that. 

With that said, **much more excited for HTMX** since I'll be back in my element -- powerfully made pages.
