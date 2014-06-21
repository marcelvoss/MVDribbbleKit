//
//  MVPlayer.h
//  DribbbleExample
//
//  Created by Marcel Voß on 15.06.14.
//  Copyright (c) 2014 Marcel Voss. All rights reserved.
//

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
