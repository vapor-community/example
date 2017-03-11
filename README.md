# Michigan Swift's Website

This is the source code of [MiSwift.com](http://www.miswift.com) [![PRs Welcome](https://img.shields.io/badge/prs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

## Community 

Join us on [Slack](http://bit.ly/miswift) and [Meetup](http://www.meetup.com/mi-swift).
[![Slack Status](https://aaswift.herokuapp.com/badge.svg?style=flat-square)](https://aaswift.herokuapp.com)

## Deploy

Approved pull requests are automatically deployed. 

## Documentation

We're working on this.

## Requirements

Swift 3.0 preview 2 is required (Xcode 8 beta 2 on macOS). 

Run the following script to check if you have Swift 3.0 beta 2 properly installed and configured.

```
curl -sL check.qutheory.io | bash
```

## Building

Visit [Getting Started](http://docs.qutheory.io) in the documentation.

### Compiling

If you have the [Vapor Toolbox](https://github.com/qutheory/vapor-toolbox), use `vapor new <project-name>` to create your new application.

Then run `vapor build` and `vapor run`.

Otherwise, clone this repo and run `swift build` to compile your application, then run `.build/debug/App`.

### Xcode 8

Run `vapor xcode` which will create the Xcode Project and open Xcode 8.

![Xcode](https://cloud.githubusercontent.com/assets/1342803/15592631/3e740df8-2373-11e6-8624-3c89260322aa.png)

