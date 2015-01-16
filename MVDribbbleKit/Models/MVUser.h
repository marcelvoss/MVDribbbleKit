// MVPlayer.h
//
// Copyright (c) 2014-2015 Marcel Voss
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

#import "MVModel.h"

typedef NS_ENUM(NSInteger, AccountType) {
    AccountTypeTeam,
    AccountTypeUser,
    AccountTypePlayer,
    AccountTypeProspect
};

@interface MVUser : MVModel

@property (nonatomic) NSURL *avatarURL;
@property (nonatomic, copy) NSString *bio;
@property (nonatomic) NSDate *createdDate;
@property (nonatomic) NSNumber *followersCount;
@property (nonatomic) NSNumber *followingsCount;

@property (nonatomic) NSURL *htmlURL;
@property (nonatomic) NSURL *followersURL;
@property (nonatomic) NSURL *followingURL;
@property (nonatomic) NSURL *likesURL;
@property (nonatomic) NSNumber *userID;
@property (nonatomic) NSNumber *likesCount;

@property (nonatomic) NSDictionary *links;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, getter = isPro) BOOL pro;
@property (nonatomic) NSNumber *shotsCount;

@property (nonatomic) NSURL *shotsURL;
@property (nonatomic) NSURL *teamsURL;
@property (nonatomic) AccountType accountType;
@property (nonatomic) NSDate *updatedDate;
@property (nonatomic, copy) NSString *username;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
