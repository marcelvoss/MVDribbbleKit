//
//  MVShot.h
//  DribbbleExample
//
//  Created by Marcel Voß on 15.06.14.
//  Copyright (c) 2014 Marcel Voss. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MVPlayer.h"

@interface MVShot : NSObject

@property (nonatomic) NSNumber *shotID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *description;

@property (nonatomic) NSURL *url;
@property (nonatomic) NSURL *shortURL;
@property (nonatomic) NSURL *imageURL;
@property (nonatomic) NSURL *imageTeaserURL;

@property (nonatomic) CGSize imageSize;

@property (nonatomic) NSNumber *viewsCount;
@property (nonatomic) NSNumber *likesCount;
@property (nonatomic) NSNumber *commentsCount;
@property (nonatomic) NSNumber *reboundsCount;

@property (nonatomic) NSNumber *reboundSourceID;
@property (nonatomic) NSDate *createdDate;

@property (nonatomic) MVPlayer *player;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
