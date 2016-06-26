<p align="center" >
	<a href="https://github.com/marcelvoss/MVDribbbleKit"><img src="Logo.png" alt="Logo" title="MVDribbbleKit"></a>
</p>


MVDribbbleKit is a modern, full-featured and well-documented Objective-C wrapper for the official [Dribbble API v1](https://dribbble.com/api).

One of the main goals was to create a wrapper, that requires as few dependencies as possible. Apart from that, I also wanted to write clean code, provide a good documentation and guarantee stability.

Make sure to read the [Terms & Guidelines](http://developer.dribbble.com/terms/) before using Dribbble's API.

**Important:** this library requires **iOS 7 or later**.

## Installation
### CocoaPods
MVDribbbleKit is available via [CocoaPods](http://cocoapods.org/). Add the following to your Podfile, install it and you are ready to go:

`
pod 'MVDribbbleKit', '~> 0.2'
`

### Without CocoaPods
Download the latest version, drop the MVDribbbleKit folder to your project and #import it. Then you have to do the same for the two third party libraries: SSKeychain and ISO8601DateFormatter.

## Usage
### Authenticating
In order to interact with the API, you have to [register your application](https://dribbble.com/account/applications/new). After the registration you'll get a client key and a client secret. Store them somewhere inside your source code. Then set the three parameters and call the authorization method:

``` objc
[manager setClientID:@"Client ID" clientSecret:@"Client Secret" callbackURL:@"Callback URL"];
[manager authorizeWithCompletion:^(NSError *error, BOOL stored) {
	// Returns a boolean value with the result of saving the access token to the keychain
}];
```

The callbackURL has to be equal to the one you've set while registering your application on Dribbble. Otherwise the authorization process is going to fail.

By default all four scopes (write, public, comment, upload) are selected. If you want to specify them you can do that by assigning their names as an array of strings to the scopes property:

``` objc
manager.scopes = @[@"write", @"public", @"comment", @"upload"];
```

**Reminder:** MVDribbbleKit stores the access token automatically to the keychain, so you don’t have to take care of that.

### Requests
It is easy to make requests and if you have ever used AFNetworking you will feel right at home because the methods are very similar to AFNetworking's (but this library doesn't use AFNetworking at all). For example, you can follow a user with the following code:

``` objc
[manager followUserWithID:@"simplebits" success:^(NSHTTPURLResponse *response) {
	NSLog(@"Response: %@", response);
} failure:^(NSError *error, NSHTTPURLResponse *response) {
	NSLog(@"Error: %@ \nResponse: %@", error, response);
}];
```

Yup, that's it. Everything else is similar to this. Let's take another example. Here's how to get the details for a user:

``` objc
[manager getDetailsForUser:@"simplebits" success:^(MVUser *user, NSHTTPURLResponse *response) {
	NSLog(@"Username: %@ \nName: %@", user.username, user.name);
} failure:^(NSError *error, NSHTTPURLResponse *response) {
	NSLog(@"Error: %@ \nResponse: %@", error, response);
}];
```

Easy, huh? 

### Models
There are also seven model classes available to make your life a bit easier. These will be used to wrap everything into native foundation objects.

* MVLike
* MVAttachment
* MVComment
* MVShot
* MVUser
* MVBucket
* MVProject

## TODO
* Replace the AuthBrowser class with an implementation of SFSafariViewController
* Simplify the API
* Add option for access keys
* Add better CocoaPods support
* Add demo project
* Add unit tests

## License
MVPopupController is released under the [MIT License](https://github.com/marcelvoss/MVDribbbleKit/blob/master/LICENSE.md).
