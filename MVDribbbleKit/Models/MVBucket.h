//
//  MVBucket.h
//  DribbbleTest
//
//  Created by Marcel Voß on 27.09.14.
//  Copyright (c) 2014 Marcel Voss. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MVUser.h"

@interface MVBucket : NSObject

@property (nonatomic) NSNumber *bucketID;
@property (nonatomic) NSString *bucketName;
@property (nonatomic) NSString *bucketDescription;
@property (nonatomic) NSNumber *shotsCount;
@property (nonatomic) NSDate *createdDate;
@property (nonatomic) NSDate *updatedDate;

@property (nonatomic) MVUser *user;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
