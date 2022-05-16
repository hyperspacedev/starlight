# Hyperspace Codename Starlight Project Contribution Guidelines (version 1)

Thank you for contributing to the Codename Starlight! To make the contribution process quick, smooth, easy, and fun, we've devised a set of guidelines. Please consult these when making a pull request, issue, etc.

## General Code Guidelines

These guidelines apply to code that is written in the Codename Starlight Project.

### Declare styles with components (NEW)

Codename Starlight 1.0 uses the [SwiftUI](https://developer.apple.com/xcode/swiftui/) framework to create beautiful and concise designs that scale across devices. Part of using this framework includes defining views right inside of the code using SwiftUI's declarative syntax as SwiftUI views. As such, we recommend adding a file dedicated to your views in the `Shared/Components` directory.

### If possible, use a type.

Codename Starlight uses custom data models - or types - via [Swift structs](https://docs.swift.org/swift-book/LanguageGuide/ClassesAndStructures.html) to specify variables, parameters, and other parts of code to prevent ambiguity. If it is possible to use an existing type from `Shared/Models` (or other types from project libraries) or make a new type, use it.

Suffice to say, this also means that new components or code _must_ be written in Swift, and all files must end with the extension `.swift`, and _never_ using Objective-C.

### Keep code organized

Codename Starlight's structure is organized based on utilities, components, tests, and other types of files to make everything easy to locate. Please try to keep this organization when making a new component or test.

### Always, please, always, use Swiftlint.

Codename Starlight includes configurations for using Realm's Swiftlint code formatter to format swift code in the project. Please ensure your code has been properly formatted by Swiftlint before submitting any to a pull request.

## Issues

These guidelines apply to issues on GitHub.

### Be as descriptive and concise as possible

So that Codename Starlight contributors and developers can better understand what the issue or request may be, issue descriptions should be concise but also descriptive. Refrain from writing an issue in a convoluted way that confuses others.

Additionally, if you feel using a screenshot or video will better illustrate your description, add them in conjuction with (or to replace) the description. Remember to consult the [Screenshot Guidelines](#screenshots).

### Label your issue during creation

Issues are categorized by types such as `bug`, `enhancement`, `question`, etc. by contributors that can access labels. Since it isn't possible to tag an issue during creation, prepend the tag to your issue's title.

> Example: [Enhancement request] Support iCloud syncing for settings

## Pull Requests

These guides apply to pull requests on GitHub.

### Describe all of your changes

Pull requests generally include many changes that address a particular problem or a set of problems. Explain all of the changes you made, but refrain from listing all of these changes as commit messages.

> Example:
> This PR makes the following changes:
>
> - Custom emojis from the user's server can be used in a post by typing its shortcode or inserting it through the new emoji picker*.
> - Posts and profile names display custom emoji.

### Reference existing issues and PRs

If applicable, pull requests will reference the issues they are fixing in the description. This helps organize contributions in a few ways:

- Automates closing issues when they are fixed
- Verifies that the pull request fixes the issue(s) in question
- Makes a reference in the issue's thread for context

If there are any documented issues that the pull request addresses, reference them in the description of the pull request.

> Example:
>
> - Use iCloud to sync data (fixes #1)

### (Optional) Sign-off your code

Codename Starlight contributors - or basically anyone who works in open-source projects - try to credit pull request contributors in release notes as a way of saying thanks. Another way to ensure that we credit the right person is by signing-off your code. This can be done either in the pull request's description or the latest commit pushed to branch linked with the pull request:

```
Signed-off-by: Your Name <youremail@email.com>
```

This isn't required but is good practice to confirm that you wrote the code so we can credit it accordingly.

## Screenshots

These guidelines apply to screenshots that are used for reference in issues and/or pull requests.

### Respect the post author's visibility

Mastodon supports posting to four different visibility levels. As a means of respecting privacy, please keep in mind the following:

- Do not post a status published as a direct message, followers-only, or unlisted status _unless_ you have explicit permission from the status author.
  - If you made a direct message to yourself to demo a feature or fix a bug present in a post, you do not need to worry.
- If you are unsure whether a public status should be included in a screenshot, consult the post author.

### Ensure screenshots are clear

Screenshots are often included to help illustrate or demonstrate a point with an issue or pull request. It may be difficult to understand the screenshot's purpose if the image is too small or distorted. Ensure that all screenshots are clear and visible.

## Code comments
To make it easier for contributors to maintain Codename Starlight's code, we use Swift's standard markdown in comments. This is important not only because it helps to organize our code and make it cleaner, but it also allows Xcode to show a quick preview of, for example, what a function does, or what arguments a class takes; when you right-click a symbol and select `Show quick help`.

```swift
/// This is a *cool* class that allows you to do **cool things** 😎.
class coolClass {

    // MARK: - STORED PROPERTIES
    
    /// This is some class property that is supposed to do something useful but im not sure.
    public var argument1: String
    
    /// This is another class property that is also supposed to do something useful but im also not sure.
    public var argument2: String

    // MARK: - INITIALIZERS

    /// - Parameters
    ///     - argument1: some argument with the type `String` that does something useful.
    ///     - argument2: some argument with the type `String` that does something useful.
    public init(
        argument1: String,
        argument2: String
    ) {
        self.argument1 = argument1
        self.argument2 = argument2
    }
    
    // MARK: - COMPUTED PROPERTIES
    
    /// This is an example of a computed property.
    private let someComputedProperty: Int

}
```

There're many guides on how to use this type of Markdown, and we strongly encourage it's use.
