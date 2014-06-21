//
//  MVComment.h
//  DribbbleExample
//
//  Created by Marcel Voß on 15.06.14.
//  Copyright (c) 2014 Marcel Voss. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MVPlayer.h"

@interface MVComment : NSObject

@property (nonatomic) NSNumber *commentID;
@property (nonatomic) NSString *body;
@property (nonatomic) NSNumber *likesCount;
@property (nonatomic) NSDate *createdDate;
@property (strong, nonatomic) MVPlayer *player;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
