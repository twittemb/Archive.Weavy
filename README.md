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

# How do I Weave my application ?
