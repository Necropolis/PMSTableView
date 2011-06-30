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