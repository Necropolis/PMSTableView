# PMSTableView

**Ten-seconds in an Elevator Sales Pitch**: _Use this to handle the "when to load paginated data asynchronously" question in order to save yourself some time and money._

**Because Whatever Doesn't Have to Suck** obligatory tagline: _Because loading stuff into a table view doesn't have to suck!_

In iOS programming, there's a lot of boring, repetitive coding surrounding `UITableView` when populating those items from a network source. You've probably thought this before:

- What if the data is too large?
- Am I transmitting too much over the air?
- What if it runs out of memory?
- Oh crap, I want to add another section to the table view!
  - Now I have to re-write everything!
- At least I'm getting paid for this! (Right?)

All of the above thoughts aren't great. It costs you time and your employer money. What's worse is when you have to deal with paginated results from the server. You know, you chunk it up before transmitting it because *usually* the user doesn't actually want all 99 bajillion results. Maybe just the first ten or twenty.

Coding for paginated data is tough. You want it to be seamless - the user scrolls down and then it automatically goes out for more data. It's simple enough to program, but it still takes time and debugging effort. Shouldn't there be a better way?

Yes, and that better way is just stealing some other bloke's code to do it for you.

## What Will It Do?

`PMSTableView` will handle the detection of when to request more data from a data source, and will send this request off asynchronously, and also stores the data itself internally. It will request your code (the delegate) to configure a `UITableViewCell` to display. It does not make many assumptions about layout - all it does is manage data, when to fetch more data, and when it's displayed.

## How Does It Do It?

`PMSTableView` is a subclass of `UITableView`. It's pretty quirky: it sets itself as the delegate and ensures that the data source is `nil`. You need to implement `PMSTableViewDelegate`, which is an extension of `UITableViewDelegate`. `PMSTableView` will intercept relevant `UITableViewDelegate` calls to know when to request more data to display. Most `UITableViewDelegate` calls are forwarded straight to the `PMSTableViewDelegate`.

## Why Is This Better Than The Last Version?

This was previously `PMSTableViewController`, which was pretty spiffy. However, it didn't use too many Cocoa design patterns and it generally was just a little confusing. It was designed to take a normal `UITableView` and manipulate it. So ultimately there was a delegate chain from the `UITableView` to `PMSTableViewController` to your code implementing `PMSTableViewControllerDelegate`. It was a lot of typing and I wasn't very happy with it.

This new version subclasses `UITableView` directly, and is itself the delegate. It doesn't prevent you from implementing your own responders to the `UITableViewDelegate`; in fact, most of those methods just pass right back to your code. Only a few are intercepted to handle the logic part of `PMSTableView`. It uses some runtime inspection to do this.

Additionally, this version has been written with LLVM 3.0 in mind. The exposed interface is much simpler, and it will adapt to ARC and truly non-volatile ivars very well.