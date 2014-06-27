# MVDribbbleKit
MVDribbbleKit is a modern, simple and well-documented Objective-C wrapper for the official [Dribbble API](https://dribbble.com/api).

No dependencies are needed, but **iOS 7 or later** or **OS X 10.9 or later** is required because this wrapper is build on top of NSURLSession.

## Installation
MVDribbbleKit is available via CocoaPods. Simply add the following to your Podfile:<br />
`pod 'MVDribbbleKit', '~> 0.1.0'`. Boom!

If you don't use CocoaPods, add the MVDribbbleKit folder to your project and `#import` it.

There are also three model classes included (MVComment, MVShot and MVPlayer) to wrap the retrived data into objects.

## API Infomation
You don't need authentication keys at the moment. API calls are limited to **60 per minute** and **10,000 per day**.

For more information visit the [API website](https://dribbble.com/api).

## License
MVDribbbleKit is available under the MIT license. See the [LICENSE](https://github.com/marcelvoss/MVDribbbleKit/blob/master/LICENSE.md) file for more information.