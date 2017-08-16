# About
Weavy is a navigation framework for iOS applications based on a weaving pattern

# Navigation concerns
Regarding navigation within an iOS application, two choices are available:
- Use the builtin mechanism provided by Apple and Xcode: the segues
-  Implement a custom mechanism directly in the code

The disadvantage of these two solutions:
- Builtin mecanism: navigation is relatively static and the storyboards are massive. The navigation code pollutes the UIViewControllers
- Custom mecanism: code can be difficult to set up and can be complex depending on the chosen design pattern (Router, Coordinator)

# Weavy aims to
- Promote the cutting of storyboards into atomic units to enable collaboration and reusability of UIViewControllers
- Allow the presentation of a UIViewController in different ways according to the navigation context
- Ease the implementation of dependency injection
- Remove any navigation mechanism from UIViewControllers 
- Promote reactive programing
- Express the navigation in a declarative way while addressing the majority of the navigation cases
- Facilitate the cutting of an application into logical blocks of navigation

# The weaving analogy

## According to Wikipedia

> Weaving involves using a **loom** to interlace two sets of threads at right angles to each other: the **warp** which runs longitudinally and the **weft** that crosses it [...] The method in which these threads are inter-woven affects the characteristics of the cloth. Cloth is usually woven on a **loom**, a device that holds the **warp** threads in place while filling **wefts** are woven through them.

## What the heck does this have to do with navigation ?

As my experience grew as an iOS developper (as well as an Android or a Web app developper), I constantly faced the same doubts regarding navigation. For all other conception issues, there were plenty of patterns to address common architecture questions and separation of concerns needs (MVC, MVP, MVVM, VIPER, Dependency Injection, Facade, Protocol Oriented Programing, Reactive programing, ...). 

But I was torn appart as soon as navigation was to be designed: 
- How do I use dependency injection with Storyboards/Segues ? 
- How do I control the flow of the application ?
- How do I get rid of the navigation boilerplate code from the ViewControllers ?

As time went by, my conception of an iOS application went from MVCs with one Storyboard, to MVCs with multiple Storyboards, to finally reach what we could name one of the nowadays best practices: MVVM with Coordinator flows. Which is perfectly fine because we can play with dependency injection, ViewControllers reusibility, testability. I had the chance to apply this pattern to huge and complex applications in production. But in the end, there were still a couple of issues that bothered me:
- I always had to write the Coordinator pattern, again and again,
- there were a lot of delegation patterns used to allow ViewModels to communicate back with Coordinators.

I began to look at the Redux pattern, especially the navigation state mechanism. We could have a global navigation state, exposed with a RxSwift Observable, and something listening to this state and driving the navigation. The only thing that I found disturbing was the uniqueness of this navigation state, and the uncontroled responsabilities it could have (as well as the massive data it could store) 

The idea that the navigation was only the reflexion of a state that could be modified step by step begun to emerge. A state that would be spread within the whole application structure, not stored in a single place, but unified by an observer that could react to it and drive the navigation as a consequence. Later in this Readme, these little states spreaded in the application are called the **Wefts** and the observer is called the **Loom**. We begin to make the link between navigation and weaving: Navigating is like inserting some presentation code bit by bit as the user plays with the application and modify all these little navigation states. In the end, navigation forms a pattern, pretty much the same idea than when a real loom weaves some fabric with wool. This pattern is unique and represent the usage of the application from opening to ending. For those who are familiar with Aspect Oriented Programming, I find the idea of "navigation weaving" pretty close to what we can find in AOP. The navigation actions would be some **advices** injected in specific **join-points** through a **weaving** process.

Weavy is born from all that experience and addressed the two mains concerns that remained from the Coordinator pattern:
- the developper must no more write Coordinators, he only has to declare the navigation and the states it react to,
- delegation is not needed anymore, since states are RxSwift Observable observed by the **Loom**

# The core principles

## Warp, Weft and Stitch
Combinaisons of Warps and Wefts describe all the possible navigation patterns within your application.
Each warp defines a clear navigation area (that makes your application divided in well defined parts) in which every Weft represent a specific presentation of a screen. This representation is called a Stitch. A Stitch can be presented in different ways such as "popup" or regular "show" screens.

## Weftable
The basic principle of navigation is very simple: it consists of successive views transitions in response to application state changes. These changes are usually due to users interactions (such as button clicking or list picking), but they can also come from a low level layer of your application. We can imagine that a lose of network session could lead to a signin screen appearance.

The most generic way of considering all this is to imagine that anything in the application can lead to a change of navigation state. We need a way to express these changes. As we saw, a combinaison of a Warp and a Weft represent a navigation action. As well as Warps can define your application areas, Wefts can define these navigation state changes inside these areas.

Considering this, a Weftable is basically "something" in the application which is able to express a new Weft, and as a consequence a navigation state change, leading to a navigation action.

A Weft can embed inner values (such as Ids, URLs, ...) that will be propagated to screens presented by the weaving process.

## Loom
A loom is a just a tool for the developper. Once he has defined the suitable combinations of Warps and Wefts representing the navigation possibilities, the job of the loom is to weave these combinaisons into patterns according to navigation state changes induced by Weftables. It is up to the developper to:
- define the Warps that represent in the best possible way its application sections (such as Dashboard, Onboarding, Settings, ...) in which significant navigation actions are needed
- provide the Weftables that will trigger the Loom weaving process.

## Woolbag
One of the goal of "Weavy" is to promote dependency injection, for valuable reasons:
- avoid using singletons everywhere in your code to reach some low level services
- separate the concerns. It is not the responsability of UIViewControllers, View Models, Presenters or whatever business logic layer to know what types of service to instantiate. They just have to use them, or at least one of their abstraction, and be flexible to an implementation change that can happen in the futur.
- being able to chose the implementations of services that will be injected to all layers of your application in a early stage of its runtime flow can have a significant advantage in its testability. It is easy to mock services and to inject these fake ones at the application bootstrap.

Let's get back to Weavy. We saw that combinaisons of Warps and Wefts are weaved into Stitches that represent screens to be displayed. The big advantage of doing this programmatically is that we have the opportunity to inject whatever service we want into the UIViewControllers the Loom will instantiate. The only thing we need at this point is a a mechanism that will help the developper to provide these services.

As well as real Wool is the raw stuff needed to weave some fabric when a warp and a weft are knitted, we need some kind of WoolBag in which developpers will store references to the services that will be needed by the UIViewControllers when they are weaved.

WoolBags are basically containers that can be injected into whatever the Loom can produce (UIViewControllers, View Models, ...).

## Demo Application
A demo application is provided to illustrate the core mechanisms of weaving. It consists of:
- a main ApplicationWarp that represents the basic application navigation (a dashboard composed of two screens in a navigation stack)
- an OnboardingWarp that represents an onboarding wizard that can be triggered within the first dashboard page (or automatically after 10s). The onboarding is composed of three screens in a navigation stack)
- a SettingsWarp that represents the settings pages that can be triggered within the second dashboard page. The settings are composed of two screens in a navigation stack.

As we can see, some screens (the login screen for instance) are defined once but used in multiple Warps in different presentation styles. We can clearly see the benefits of decoupling navigation from UIViewControllers.

# Tools & dependencies

Weavy relies on:
- SwiftLint for static code analysis ([Github SwiftLint](https://github.com/realm/SwiftLint))
- RxSwift to expose Wefts into Observables the Loom can react to ([Github RxSwift](https://github.com/ReactiveX/RxSwift))
- RxSwiftExt which adds some usefull reactive operators not included in RxSwift ([Github RxSwiftExt](https://github.com/RxSwiftCommunity/RxSwiftExt))
- Reusable in the Demo App to ease the storyboard cutting into atomic ViewControllers ([Github Reusable](https://github.com/AliSoftware/Reusable))
