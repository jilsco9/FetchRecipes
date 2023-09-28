#  Fetch Recipes

## General Notes

This app is created to demonstrate a generalized approach to  app architecture and maintenance. There are some improvements that I would make in order to make it production-ready, detailed alongside some general notes below.

## Architecture

This app does not use traditional view models, instead opting for Apple-consistent SwiftUI patterns, in this case one that use models and client/providers.

This pattern is not always feasible. Sometimes there is more logic required to prepare models for UI presentation, and I think view models are a solution that is both testable and workable.

## Localization

I did not include localization in this app. There are a number of places I would make changes to facilitate localization, for example leveraging LocalizedError instead of Error, LocalizedKey instead of String literals in SwiftUI.

## Testing

I did minimal testing to demonstrate a couple areas where unit testing would be helpful. Normally, I'd ideally extend unit testing by creating full Test Plans and multiple files organized by the models/utilities they test. I also did not include UI testing or any testing measuring time, both of which would normally be important in a project setting and a production app.

## Offline persistence

This app lends itself well to caching using either Core Data or SwiftData; however, this seemed beyond the scope of the app. I did include caching using NSCache for the MealDetails to ensure data that has already been fetched does not need to be re-fetched while the app is running.

## User experience

While I presented information in a pretty standard way, I tried to make it readable and iOS-standard. With more time, I'd like to expand on the MealDetails UI, and maybe present some of the information with a little more pizzazz.

## Accessibility

I used system font sizing for all text, so dynamic type should function natively. But ideally, I'd spend some time running the app at various dynamic type text sizes. I'd also check the screen reader, switch, and contrasts, ideally including accessibility audit automation.

## Other considerations

There are a few other areas where I would make improvements if this were to be a production app. I would like to spend more time verifying how the API delivers data. I tried to convert data where it made sense, but I may not have caught all possible outcomes of data delivery. I initially included but then commented out a piece of code that sorts the meals list alphabetically; it seemed the API delivered the list already sorted, but it would be nice to verify that would always be the case. I left the code in the repo, but commented, to demonstrate one way I could accomplish sorting if needed. I also probably added more comments than necessary in the MealClient and MealDetails, but there were decisions and logic in those two files, above others, that merited some explanation. Overall, I think this code base demonstrates some thoughtfulness around the ways in which I handle considerations of workign with data, creating usable models, displaying information, and working with scalability in mind, while also being sure not to overcomplicate any solutions unnecessarily. Above all, it's most important that the code works and that any future devs who work in the code base can pick it up and work with it relatively seamlessly.
