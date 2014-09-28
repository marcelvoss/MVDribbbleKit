# MVDribbbleKit
MVDribbbleKit is a modern and full-featured Objective-C wrapper for the official [Dribbble API v1](https://dribbble.com/api).

No dependencies are needed, but **iOS 7 or later** or **OS X 10.9 or later** is required because this wrapper makes use of NSURLSession.

Make sure that you read the [Terms & Guidelines](http://developer.dribbble.com/terms/) before using it.

**Important: it is not recommended to use the current version in production.**

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

### Requests
It is easy to make requests and if you have ever used AFNetworking you will feel right at home because the methods are very similar to AFNetworking's. For example, you can follow a user with the following code:

``` objc
[manager followUserWithID:@"simplebits" success:^(NSHTTPURLResponse *response) {
	NSLog(@"%@", response);
} failure:^(NSError *error, NSHTTPURLResponse *response) {
	NSLog(@"Error: %@, Response: %@", error, response);
}];
```

Yup, that's it. Everything else is similar to this. Let's take another example. Here's how to get the details for a user:

``` objc
[manager getDetailsForUser:@"simplebits" success:^(MVUser *user, NSHTTPURLResponse *response) {
	NSLog(@"Username: %@ \n Name: %@", user.username, user.name);
} failure:^(NSError *error, NSHTTPURLResponse *response) {
	NSLog(@"Error: %@, Response: %@", error, response);
}];
```

Easy, huh? There are also six model classes available (MVLike, MVAttachment, MVComment, MVShot, MVUser, MVBucket). These will be used to wrap everything into native foundation objects.

## Credits
Thanks to the API team at Dribbble for giving me early access to the new API version, so I was able to update MVDribbbleKit before the public release.

## License
MVDribbbleKit is available under the MIT license. See the [LICENSE](https://github.com/marcelvoss/MVDribbbleKit/blob/master/LICENSE.md) file for more information.