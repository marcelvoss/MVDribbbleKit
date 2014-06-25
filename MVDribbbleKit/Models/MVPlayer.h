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

@interface MVPlayer : NSObject

@property (nonatomic) NSNumber *playerID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *twitterScreenName;
@property (nonatomic) NSNumber *draftedByPlayerID;

@property (nonatomic) NSURL *avatarURL;
@property (nonatomic) NSURL *url;

@property (nonatomic) NSNumber *shotsCount;
@property (nonatomic) NSNumber *drafteesCount;
@property (nonatomic) NSNumber *followersCount;
@property (nonatomic) NSNumber *followingCount;
@property (nonatomic) NSNumber *commentsCount;
@property (nonatomic) NSNumber *commentsReceivedCount;
@property (nonatomic) NSNumber *likesCount;
@property (nonatomic) NSNumber *likesReceivedCount;
@property (nonatomic) NSNumber *reboundsCount;
@property (nonatomic) NSNumber *reboundsReceivedCount;

@property (nonatomic) NSDate *createdDate;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
