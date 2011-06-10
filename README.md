# PMSTableViewController

PaginatedMultiSourceTableViewController (`PMSTableViewController`) is an Objective-C class that abstracts the logic of loading data into a `UITableView` from an asynchronous source in a paginated (piecemeal) manner.

I built this because I saw that I was about to write this code at work, and I didn't want to have to type it all out a million times, so I made a nicer abstract controller to reduce the workload. This is BSD/MIT dual-licensed so I can use it at work, at play, and everywhere else; consequentially, you can use it, too.

Please see the example code for ideas of how it's used, and feel free to modify it to your heart's content. If you'd backport any of those modifications back to me, I'd absolutely love that, but it's not required.

Happy coding!

## Basic Usage Overview

There is one main class that you need to know about: `PMSTableViewController`. This class contains the logic that detects when the user has scrolled to the end of a list of items and then runs off to fetch more data from your code.

You communicate with `PMSTableViewController` by implementing `PMSTableViewControllerDelegate`. From here you can return the proper data to the `UITableView`, generate your own `UITableViewCell`s (style them, inject edit hooks, etc) and otherwise do a lot of different things.

Each `PMSTableViewController` splits the `UITableView` into one or more sections. Each section represents a different source of data. I could be loading data from a network connection, from a large file, or by randomly generating numbers. The advantage of having multiple data sources for a single table is that it allows you to combine two views into one (where this makes sense).

`PMSTableViewController` is in essence an easy framework to implement "infinite scrolling" on the iOS. It doesn't try to load any more data until it needs to.

I think I'm correct in saying that `PMSTableViewController` isn't really the easiest to understand piece of code out there. However, if you ever find yourself in a situation of needing what it offers, then you will completely understand it. It will save you quite a lot of time and typing! However, I believe that I'm also correct in saying that `PMSTableViewController` is a bit of a niche tool; not many people even have the need of it.

## Future Features

What would I like to add in the future (approximately whenever I get a mythical Round Tuit)?

* Inject a loading cell while loading more content.
* Refactor how new cells are injected. I'm downright certain I'm not doing it in the best way.
* Build a few more examples to make it easier to deduce how to use it.

# License

Firestorm Development Open-Source License
Version 0.1 - http://fsdev.net/FDOSL.html

This software is licensed under the _Firestorm Development Open-Source License_, which is a dual-licensing under the BSD and MIT license. Pursuant to these terms, you may use this software under the terms of either the BSD or MIT licenses – not both. One or the other, no mix-and-match. The license text of both licenses follows for clarity:

*2-clause BSD License*

> Copyright 2010, 2011 FSDEV. All rights reserved.
> 
> * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
> 
> * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
> 
> * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
> 
> THIS SOFTWARE IS PROVIDED BY FSDEV "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL FSDEV OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> 
> The views and conclusions contained in the software and documentation are those of the authors and should not be interpreted as representing official policies, either expressed or implied, of FSDEV.

*MIT License*

> Copyright (c) 2010, 2011 FSDEV
> 
> Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
> 
> The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.