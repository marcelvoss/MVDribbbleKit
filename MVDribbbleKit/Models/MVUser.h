// MVPlayer.h
//
// Copyright (c) 2014 Marcel Voss
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AccountType) {
    AccountTypeTeam,
    AccountTypeUser,
    AccountTypePlayer,
    AccountTypeProspect
};

@interface MVUser : NSObject

/**
 *  An NSURL object that contains the URL to the user's avatar.
 */
@property (nonatomic) NSURL *avatarURL;

/**
 *  An NSString object that contains the user's bio.
 */
@property (nonatomic, copy) NSString *bio;

/**
 *  An NSDate object that contains the creation date of the account.
 */
@property (nonatomic) NSDate *createdDate;

/**
 *  An NSNumber object that contains the followings count.
 */
@property (nonatomic) NSNumber *followersCount;

/**
 *  An NSNumber object that contains the followings count.
 */
@property (nonatomic) NSNumber *followingsCount;

/**
 *  An NSURL object that contains the HTML URL.
 */
@property (nonatomic) NSURL *htmlURL;

/**
 *  An NSURL object that contains the followers URL.
 */
@property (nonatomic) NSURL *followersURL;

/**
 *  An NSURL object that contains the likes URL.
 */
@property (nonatomic) NSURL *likesURL;

/**
 *  An NSNumber object that contains the user ID.
 */
@property (nonatomic) NSNumber *userID;

/**
 *  An NSNumber object that contains the number of likes the user has given.
 */
@property (nonatomic) NSNumber *likesCount;

/**
 *  A dictionary of user links. Possible keys are 'twitter' and 'web'.
 */
@property (nonatomic) NSDictionary *links;

/**
 *  An NSString object that contains the user's location.
 */
@property (nonatomic, copy) NSString *location;

/**
 *  An NSString object that contains the user's name.
 */
@property (nonatomic, copy) NSString *name;

/**
 *  A boolean value that defines weather the user is a pro or not.
 */
@property (nonatomic, getter = isPro) BOOL pro;

/**
 *  An NSNumber object that contains the number of uploaded shots by the user.
 */
@property (nonatomic) NSNumber *shotsCount;

/**
 *  An NSURL object that contains the shots URL.
 */
@property (nonatomic) NSURL *shotsURL;

/**
 *  An NSURL object that contains the teams URL.
 */
@property (nonatomic) NSURL *teamsURL;

/**
 *  <#Description#>
 */
@property (nonatomic) AccountType accountType;

/**
 *  An NSDate object that contains the last date when the user updated his profile.
 */
@property (nonatomic) NSDate *updatedDate;

/**
 *  An NSString object that contains the username of the user.
 */
@property (nonatomic, copy) NSString *username;

/**
 *  Creates and returns a new MVUser object.
 *
 *  @param dictionary A dictionary that should be used to initialize the new object.
 *
 *  @return An MVUser object.
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
