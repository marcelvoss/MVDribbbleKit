# MVDribbbleKit
MVDribbbleKit is a modern, full-featured and well-documented Objective-C wrapper for the official [Dribbble API](https://dribbble.com/api).

No dependencies are needed, but **iOS 7 or later** or **OS X 10.9 or later** is required because this wrapper makes use of NSURLSession.

## Installation
### CocoaPods
MVDribbbleKit is available via CocoaPods. Simply add this to your Podfile: `pod 'MVDribbbleKit', '~> 1.0'` and install it with `pod install`. Boom!

### Without CocoaPods
Download the latest version, add the MVDribbbleKit folder to your project and import it.

## Usage
### Authenticating
In order to interact with the API, you have to [register your application](https://dribbble.com/account/applications/). After the registration you'll get a client key and a client secret. Store them somewhere inside your source code. Then set the three parameters and call the authorization method:

``` objc
[manager setClientID:@"Client ID" clientSecret:@"Client Secret" callbackURL:@"Callback URL"];
[manager authorizeWithCompletion:^(NSError *error, NSString *accessToken) {
	// Save the access token to the keychain
}];
```

The callbackURL has to be equal to the one you've set while registering your application on Dribbble. Otherwise the authorization process is going to fail.

By default all four scopes (write, public, comment, upload) are selected. If you want to specify them you can do that by assigning their names as an array of strings to the scopes property:

``` objc
manager.scopes = @[@"write", @"public", @"comment", @"upload"];
```

**Reminder:** MVDribbbleKit doesn't take care of storing the access token to the keychain. So, you have to do that on your own.

## License
MVDribbbleKit is available under the MIT license. See the [LICENSE](https://github.com/marcelvoss/MVDribbbleKit/blob/master/LICENSE.md) file for more information.