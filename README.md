<img alt="Weavy Logo" src="https://raw.githubusercontent.com/twittemb/Weavy/develop/Resources/weavy_logo.png" width="200"/> | <ul align="left"><li><a href="#about">About</a><li><a href="#navigation-concerns">Navigation concerns</a><li><a href="#weavy-aims-to">Weavy aims to</a><li><a href="#the-core-principles">The core principles</a><li><a href="#tools-and-dependencies">Tools and dependencies</a></ul>
------------------------------- | ---------------------------------
Travis CI |  [![Build Status](https://travis-ci.org/twittemb/Weavy.svg?branch=develop)](https://travis-ci.org/twittemb/Weavy)

<span style="float:none" />

# About
Weavy is a navigation framework for iOS applications based on a weaving pattern

This README is a short story of the whole conception process that leaded me to this framework.

Take a look at this wiki page to learn more about Weavy: [Weavy in details](https://github.com/twittemb/Weavy/wiki/Weavy-in-details)

# Navigation concerns
Regarding navigation within an iOS application, two choices are available:
- Use the builtin mechanism provided by Apple and Xcode: storyboards and segues
-  Implement a custom mechanism directly in the code

The disadvantage of these two solutions:
- Builtin mechanism: navigation is relatively static and the storyboards are massive. The navigation code pollutes the UIViewControllers
- Custom mechanism: code can be difficult to set up and can be complex depending on the chosen design pattern (Router, Coordinator)

# Weavy aims to
- Promote the cutting of storyboards into atomic units to enable collaboration and reusability of UIViewControllers
- Allow the presentation of a UIViewController in different ways according to the navigation context
- Ease the implementation of dependency injection
- Remove any navigation mechanism from UIViewControllers 
- Promote reactive programing
- Express the navigation in a declarative way while addressing the majority of the navigation cases
- Facilitate the cutting of an application into logical blocks of navigation

# The core principles

In a real world: *Weaving involves using a **loom** to interlace two sets of threads at right angles to each other: the **warp** which runs longitudinally and the **weft** that crosses it*

This is how I imagine the weaving pattern in a simple application:

<p align="center">
<img src="https://raw.githubusercontent.com/twittemb/Weavy/develop/Resources/weavy_weaving.png" width="480"/>
</p>

How do I read this ?

- Here we have three warps: **Application**, **Onboarding** and **Settings** which describe the three main navigation sections of the application.
- We also have three wefts: **Dashboard** (the default weft triggered at the application bootstrap), **Set the server** and **Login**.

Each one of these wefts will be triggered either because of user actions or because of backend state changes.
The crossing between a warp and a weft represented by a colored chip will be a specific navigation action (such as a UIViewController appearance).

As we can see, some wefts are used in multiple warps and their triggering will lead to the display of the same screen, but with different presentation options. Sometimes these screens will popup and sometimes they will be pushed in a navigation stack.
This sketch illustrates how we can factorize UIViewControllers and Storyboards.

## Warp, Weft and Stitch
Combinaisons of Warps and Wefts describe all the possible navigation patterns within your application.
Each **warp** defines a clear navigation area (that makes your application divided in well defined parts) in which every **weft** represent a specific presentation of a screen. This representation is called a **Stitch**. A **Stitch** can be presented in different ways such as "popup" or regular "show" screens.

## Weftable
The basic principle of navigation is very simple: it consists of successive views transitions in response to application state changes. These changes are usually due to users interactions, but they can also come from a low level layer of your application. We can imagine that a lose of network session could lead to a signin screen appearance.

We need a way to express these changes. As we saw, a combinaison of a **Warp** and a **Weft** represent a navigation action. As well as warps can define your application areas, wefts can define these navigation state changes inside these areas.

Considering this, a **Weftable** is basically "something" in the application which is able to express a new **Weft**, and as a consequence a navigation state change, leading to a navigation action.

A **Weft** can even embed inner values (such as Ids, URLs, ...) that will be propagated to screens presented by the weaving process.

## Loom
A loom is a just a tool for the developper. Once he has defined the suitable combinations of Warps and Wefts representing the navigation possibilities, the job of the loom is to weave these combinaisons into patterns, according to navigation state changes induced by Weftables. 

It is up to the developper to:
- define the Warps that represent in the best possible way its application sections (such as Dashboard, Onboarding, Settings, ...) in which significant navigation actions are needed
- provide the Weftables that will trigger the **Loom** weaving process.

## Demo Application
A demo application is provided to illustrate the core mechanisms of weaving. It consists of:
- a main ApplicationWarp that represents the basic application navigation (a dashboard composed of two screens in a navigation stack)
- an OnboardingWarp that represents an onboarding wizard that can be triggered within the first dashboard page (or automatically after 10s). The onboarding is composed of three screens in a navigation stack)

# Tools and dependencies

Weavy relies on:
- SwiftLint for static code analysis ([Github SwiftLint](https://github.com/realm/SwiftLint))
- RxSwift to expose Wefts into Observables the Loom can react to ([Github RxSwift](https://github.com/ReactiveX/RxSwift))
- RxSwiftExt which adds some usefull reactive operators not included in RxSwift ([Github RxSwiftExt](https://github.com/RxSwiftCommunity/RxSwiftExt))
- Reusable in the Demo App to ease the storyboard cutting into atomic ViewControllers ([Github Reusable](https://github.com/AliSoftware/Reusable))
